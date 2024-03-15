FROM golang:1.22 as builder

WORKDIR /

COPY ./go.mod ./
# COPY ./go.sum ./
# RUN go mod download

ADD ./ .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main main.go

FROM alpine:latest
WORKDIR /
COPY --from=builder /main ./

CMD ["/main"]
