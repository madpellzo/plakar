FROM golang:1.25.6-alpine3.23 AS builder

WORKDIR /go

ARG PLAKAR_VERSION
ENV PLAKAR_VERSION=v1.0.6

RUN apk add --no-cache git make

RUN go install "github.com/PlakarKorp/plakar@${PLAKAR_VERSION}"

RUN plakar pkg build sftp

FROM alpine:3.23

COPY --from=builder /go/bin/plakar /usr/bin/
COPY --from=builder /go/sftp_*.ptar /tmp/

RUN plakar pkg add /tmp/sftp_*.ptar && rm /tmp/sftp_*.ptar

RUN apk add --no-cache openssh rsyslog
RUN sed -i '/imklog/s/^/#/' /etc/rsyslog.conf

EXPOSE 9090

CMD ["rsyslogd", "-n", "-f", "/etc/rsyslog.conf"]
