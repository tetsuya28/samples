package main

import (
	"fmt"
	"time"

	"github.com/grafana/pyroscope-go"
)

func main() {
	pyroscope.Start(pyroscope.Config{
		ApplicationName: "sample",
		ServerAddress:   "http://localhost:4040",
		Logger:          pyroscope.StandardLogger,
		UploadRate:      1 * time.Second,
		ProfileTypes:    pyroscope.DefaultProfileTypes,
	})

	ticker := time.NewTicker(1 * time.Second)

	for {
		select {
		case <-ticker.C:
			fmt.Println("foo")
		}
	}
}
