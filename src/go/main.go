package main

import (
    "log"
	"time"
	"strconv"
	"math/rand"
	"github.com/pkg/errors"
    _ "github.com/lib/pq"
    "github.com/jmoiron/sqlx"
	"github.com/oklog/ulid/v2"
)

type Post struct {
    Id  string `db:"id"`
    Number uint64 `db:"number"`
    Created time.Time `db:"created"`
}

type Execution struct {
	CreateMultiplePost func(db *sqlx.DB, offset uint64, limit uint64, maxLine uint64, maxRetry uint64) error
	GetPostByNumber func(db *sqlx.DB, number uint64) (*Post, error)
	GetList func(db *sqlx.DB) ([]Post, error)
}

type ExecutionInterface interface {
	RunGetList(*sqlx.DB) ([]Post, error)
	RunGetPostByNumber(*sqlx.DB, uint64) (*Post, error)
	RunCreateMultiplePost(*sqlx.DB, uint64, uint64, uint64, uint64) error
}

func (p *Execution) RunGetList(db *sqlx.DB) ([]Post, error) {
	startTime := time.Now()
	posts, err := p.GetList(db)
	if err != nil {
		return nil, err
	}
	endTime := time.Now()
	duration := endTime.Sub(startTime).Seconds()
	log.Printf("getList: %v seconds\n", duration)
	return posts, nil
}

func (p *Execution) RunGetPostByNumber(db *sqlx.DB, number uint64) (*Post, error) {
	startTime := time.Now()
	post, err := p.GetPostByNumber(db, number)
	if err != nil {
		return nil, err
	}
	endTime := time.Now()
	duration := endTime.Sub(startTime).Seconds()
	log.Printf("getPostByNumber: %v seconds\n", duration)
	return post, nil
}

func (p *Execution) RunCreateMultiplePost(db *sqlx.DB, offset uint64, limit uint64, maxLine uint64, maxRetry uint64) error {
	startTime := time.Now()
	err := p.CreateMultiplePost(db, offset, limit, maxLine, maxRetry)
	if err != nil {
		return err
	}
	endTime := time.Now()
	duration := endTime.Sub(startTime).Seconds()
	log.Printf("createMultiplePost: %v seconds\n", duration)
	return nil
}

func main(){
	db, err := sqlx.Connect("postgres", "user=postgres password=postgres dbname=examples sslmode=disable port=5432")
	// db, err := sqlx.Connect("postgres", "user=pyar6329 dbname=examples sslmode=disable port=26257")
    if err != nil {
        log.Println("DB connection errored")
		return
    }

	var e ExecutionInterface = &Execution{GetList: getList, GetPostByNumber: getPostByNumber, CreateMultiplePost: createMultiplePost}
	// var offset uint64 = 1
	var offset uint64 = 9364001
	var limit uint64 = 1000
	// var maxLine uint64 = 1_000_000
	var maxLine uint64 = 10_000_000
	var maxRetry uint64 = 20
	err = e.RunCreateMultiplePost(db, offset, limit, maxLine, maxRetry)
    if err != nil {
        log.Fatalln(err)
    }

	post, err := e.RunGetPostByNumber(db, maxLine)
	if err != nil {
		log.Fatalln(err)
	}
	log.Printf("id: %v, number: %v, timestamp: %v\n", post.Id, post.Number, post.Created.String())

	// posts, err := e.RunGetList(db)
	// if err != nil {
	// 	log.Fatalln(err)
	// }
	// log.Printf("id: %v, number: %v, timestamp: %v\n", posts[0].Id, posts[0].Number, posts[0].Created.String())
}

func generateULID() string {
	t := time.Unix(1000000, 0)
	r := rand.New(rand.NewSource(t.UnixNano()))
	r.Seed(time.Now().UnixNano())
	ulid := ulid.MustNew(ulid.Timestamp(t), ulid.Monotonic(r, 0))
	return ulid.String()
}

func generatePost(number uint64) *Post {
	return &Post{generateULID(), number, time.Now()}
}

func generatePostList(offset uint64, limit uint64) []*Post {
	pl := []*Post{}
	for i := offset; i < offset + limit; {
		p := *generatePost(i)
		if i > offset && pl[len(pl)-1].Id == p.Id {
			continue
		}
		pl = append(pl, &p)
		i++
	}
	return pl
}

func bulkInsert(db *sqlx.DB, posts []*Post) (err error) {
	tx, err := db.Beginx()
	if err != nil {
		log.Println("transaction creating was failed")
		return err
	}

	defer func() {
        if r := recover(); r != nil {
			if ro := tx.Rollback(); ro != nil {
				err = errors.Wrap(err, ro.Error())
			}
			log.Println("defer recover() was failed")
			panic(r)
        } else if err != nil {
			if ro := tx.Rollback(); ro != nil {
				log.Println("rollback transaction was failed")
				err = errors.Wrap(err, ro.Error())
			}
			log.Println("rollback transaction")
        } else {
			if co := tx.Commit(); co != nil {
				err = errors.Wrap(err, co.Error())
				log.Println("commit was failed")
			}
        }
	}()

	_, err = tx.NamedExec(`insert into posts (id,number,created) values (:id,:number,:created)`, posts)
	if err != nil {
		log.Println("bulk insert was failed")
		return err
	}
	return nil
}

func createMultiplePost(db *sqlx.DB, offset uint64, limit uint64, maxLine uint64, maxRetry uint64) error {
	for i, retry := offset, uint64(0); i < maxLine; {
		if retry > maxRetry {
			log.Printf("retry %v times, but cannot insert it. offset=%v\n", maxRetry, i)
			return errors.New("multiple insert was failed")
		}
		if retry != 0 {
			log.Printf("retry %v: offset=%v\n", retry, i)
		}

		posts := generatePostList(i, limit)
		if err := bulkInsert(db, posts); err != nil {
			retry++
			continue
		}

		retry = 0
		i += limit
	}
	log.Println("finished insert")
	return nil
}

func getPostByNumber(db *sqlx.DB, number uint64) (*Post, error) {
	p := &Post{}
	err := db.Get(p, "select * from posts where number=$1", number)
	if err != nil {
		errMessage := "select was failed. number : " + strconv.FormatUint(number, 10) + "\n"
		log.Printf(errMessage)
		return nil, errors.New(errMessage)
	}
	return p, nil
}

func getList(db *sqlx.DB) ([]Post, error) {
	posts := []Post{}
	err := db.Select(&posts, "select * from posts order by created asc")
	if err != nil {
		errMessage := "select was failed"
        log.Println(errMessage)
		return nil, errors.New(errMessage)
	}
	return posts, nil
}
