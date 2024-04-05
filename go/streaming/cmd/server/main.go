package main

import (
	"fmt"
	"github.com/tetsuya28/samples/go/streaming/proto/gen"
	"net"
	"time"

	"google.golang.org/grpc"
)

func main() {
	s := grpc.NewServer()

	listener, err := net.Listen("tcp", ":8080")
	if err != nil {
		panic(err)
	}

	gen.RegisterTestServiceServer(s, &service{})

	fmt.Println("Server is running on port 8080")

	if err := s.Serve(listener); err != nil {
		panic(err)
	}
}

type service struct{
	gen.UnimplementedTestServiceServer
}

func (s *service) Hello(req *gen.HelloRequest, stream gen.TestService_HelloServer) error {
	for i := 0; i < 10; i++ {
		stream.Send(&gen.HelloResponse{Message: "Hello, World!"})
		time.Sleep(1 * time.Second)
	}
	return nil
}
