package main

import (
	"log"
)

func bar() {
	maxSize := 1_000_000
	slice := []int{}

	for i := 0; i < maxSize; i++ {
		slice = append(slice, i)
	}

	log.Println(slice[maxSize - 1])
}

