GO := go
BIN := $(abspath ./bin)
PATH := $(abspath ./bin):$(PATH)

$(BIN)/proto:
	GOBIN=$(BIN) $(GO) install github.com/bufbuild/buf/cmd/buf@latest
	GOBIN=$(BIN) $(GO) install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	GOBIN=$(BIN) $(GO) install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2

.PHONY: proto/generate
proto/generate: $(BIN)/proto
proto/generate:
	cd proto && $(BIN)/buf generate
