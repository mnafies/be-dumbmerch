FROM golang:1.16-alpine
RUN mkdir /app   
COPY . /app   
WORKDIR /app   
RUN go get ./ && go build && go mod download
EXPOSE 5000
CMD ["go", "run", "main.go"]
