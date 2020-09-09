package main

import (
	"log"
	"net/http"
	"os"

	"github.com/aws/aws-lambda-go/lambda"
)

type response struct {
	StatusCode int    `json:"statusCode"`
	Body       string `json:"body"`
}

func main() {
	if os.Getenv("ENV") == "dev" {
		log.Println(handler())
	} else {
		lambda.Start(handler)
	}
}

func handler() (response, error) {
	r := response{
		StatusCode: http.StatusOK,
		Body:       "v1",
	}
	return r, nil
}
