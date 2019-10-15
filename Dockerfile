FROM registry.cn-hangzhou.aliyuncs.com/knative-sample/golang:1.12 as builder

# Copy local code to the container image.
WORKDIR /go/src/github.com/knative-sample/grpc-ping-go
COPY . ./

# Build the command inside the container.
# To facilitate gRPC testing, this container includes a client command.
RUN CGO_ENABLED=0 go build -tags=grpcping -o ./ping-server
RUN CGO_ENABLED=0 go build -tags=grpcping -o ./ping-client ./client

FROM registry.cn-hangzhou.aliyuncs.com/knative-sample/alpine-sh:3.9

# Copy the binaries to the production image from the builder stage.
COPY --from=builder /go/src/github.com/knative-sample/grpc-ping-go/ping-server /server
COPY --from=builder /go/src/github.com/knative-sample/grpc-ping-go/ping-client /client

# Run the service on container startup.
CMD ["/server"]
