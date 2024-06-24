FROM golang:1.23rc1-alpine3.19
WORKDIR /app
COPY go.mod main.go ./

RUN go mod download
COPY . .

RUN go build -o main .

EXPOSE 8080
CMD ["./main"]