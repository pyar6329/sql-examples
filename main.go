package main

import (
    "log"
	"time"
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

func main(){
	db, err := sqlx.Connect("postgres", "user=pyar6329 dbname=examples sslmode=disable port=26257")
    if err != nil {
        log.Println("DB connection errored")
		return
    }

	var offset uint64 = 1
	var limit uint64 = 1000
	var maxLine uint64 = 1_000_000
	var maxRetry uint64 = 10

	for i, retry := offset, uint64(0); i < maxLine; {
		if retry > maxRetry {
			log.Fatalf("retry %v times, but cannot insert it. offset=%v\n", maxRetry, i)
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

	post := getPostByNumber(db, maxLine)
	log.Println("finished insert")
	log.Printf("id: %v, number: %v, timestamp: %v\n", post.Id, post.Number, post.Created.String())
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

func getPostByNumber(db *sqlx.DB, number uint64) Post {
	p := Post{}
	err := db.Get(&p, "select * from posts where number=$1", number)
	if err != nil {
		log.Printf("select was failed. number : %v\n", number)
	}
	return p
}

func getList(db *sqlx.DB) []Post {
	posts := []Post{}
	err := db.Select(&posts, "select * from posts order by created asc")
	if err != nil {
        log.Println("select was failed")
	}
	return posts
}
