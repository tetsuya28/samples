package main

import (
	"io"
	"net/http"
	"net/url"
)

func main() {
	http.HandleFunc("/", handler)
	if err := http.ListenAndServe(":8080", nil); err != nil {
		panic(err)
	}
}

func handler(w http.ResponseWriter, r *http.Request) {
	u, err := url.Parse("http://checkip.dyndns.com/")
	if err != nil {
		panic(err)
	}

	client := http.Client{}
	resp, err := client.Get(u.String())
	if err != nil {
		panic(err)
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		panic(err)
	}
	defer resp.Body.Close()

	// set body to response writer
	_, err = w.Write(body)
	if err != nil {
		panic(err)
	}
}
