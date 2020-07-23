FROM golang:1.13.4 as builder

WORKDIR /
ENV GO111MODULE on

COPY ./go.mod ./
COPY ./go.sum ./
RUN go mod download

ADD ./ .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main main.go

FROM alpine:latest
WORKDIR /
COPY --from=builder /main ./

EXPOSE 9000

CMD ["/main"]

