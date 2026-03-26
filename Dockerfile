FROM golang:1.16.0-alpine as builder

WORKDIR /app/matrixemailbridge

RUN apk add --no-cache gcc musl-dev git
RUN git clone https://github.com/jahlives/Matrix-EmailBridge.git .

WORKDIR /app/matrixemailbridge/main
RUN go get -d -v
RUN CGO_ENABLED=1 go build -o main
RUN pwd && ls -lah

FROM alpine:latest

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
WORKDIR /app

COPY --from=builder /app/matrixemailbridge/main/main .

RUN mkdir /app/data/

ENV BRIDGE_DATA_PATH="/app/data/"

CMD [ "/app/main"]
