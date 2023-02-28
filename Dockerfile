FROM golang:1.19-alpine AS build
WORKDIR /go/src/delog
COPY . .
RUN CGO_ENABLED=0 go build -o /go/bin/delog ./cmd/delog

RUN GRPC_HEALTH_PROBE_VERSION=v0.3.2 && \
    wget -qO/go/bin/grpc_health_probe \
    https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/\
    ${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 && \
    chmod +x /go/bin/grpc_health_probe


FROM scratch
COPY --from=build /go/bin/delog /bin/delog

COPY --from=build /go/bin/grpc_health_probe /bin/grpc_health_probe

ENTRYPOINT ["/bin/delog"]

