package main

import (
	"context"
	"fmt"
	"io"
	"os"
	"time"

	"github.com/tetsuya28/samples/go/streaming/proto/gen"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)


func main() {
	d := os.Getenv("TIMEOUT")
	if d == "" {
		d = "20s"
	}
	timeout, err := time.ParseDuration(d)
	if err != nil {
		panic(err)
	}

	ctx, cancel := context.WithTimeout(context.Background(), timeout)
	defer cancel()

	conn, err := grpc.DialContext(ctx, "localhost:8080", grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		panic(err)
	}

	c := gen.NewTestServiceClient(conn)
	r, err := c.Hello(ctx, &gen.HelloRequest{})
	if err != nil {
		panic(err)
	}

	for {
		resp, err := r.Recv()
		if err == io.EOF {
			return
		}
		if err != nil {
			panic(err)
		}

		fmt.Println(resp)
	}
}
