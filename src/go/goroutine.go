package main

import (
	"log"
	"sync"
)

func main() {
	maxSize := 1_000_000
	wg := &sync.WaitGroup{}
	queue := make(chan int, 1)

	wg.Add(maxSize)
	sendNumber(queue, maxSize)
	slice := receiveNumber(queue, wg)

	log.Println(slice[maxSize - 1])
}

func sendNumber(queue chan<- int, maxSize int) {
	for i := 0; i < maxSize; i++ {
		go func(i int) {
			queue <- int(i)
		}(i)
	}
}

func receiveNumber(queue <-chan int, wg *sync.WaitGroup) []int {
	slice := []int{}
	go func() {
		for t := range queue {
			slice = append(slice, t)
			wg.Done()
		}
	}()
	wg.Wait()
	return slice
}
