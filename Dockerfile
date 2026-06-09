FROM golang:1.22.5 AS builder

WORKDIR /app

COPY go.mod .

RUN go mod download

COPY . .

# RUN go build -o main .
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Final stage using a minimal distroless runtime
FROM gcr.io/distroless/static-debian12

COPY --from=builder /app/main /

COPY --from=builder /app/static /static

EXPOSE 8080

CMD [ "./main" ]