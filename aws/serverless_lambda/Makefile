ENV ?= dev

deploy: fmt
	GOOS=linux go build -o bin/main
	sls deploy --stage $(ENV)

run: fmt
	ENV=$(ENV) go run main.go

fmt:
	go fmt

get_apigateway:
	aws --region ap-northeast-1 apigateway get-rest-apis | jq -r "(.items[] | select(.name==\"$(ENV)-sample\")) | .id"

