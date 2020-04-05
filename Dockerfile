FROM golang:1.12-alpine3.10 as builder

RUN apk update && apk add sqlite-dev build-base

WORKDIR $GOPATH

ADD .git src/perkeep.org/.git
ADD app src/perkeep.org/app
ADD clients src/perkeep.org/clients
ADD cmd src/perkeep.org/cmd
ADD config src/perkeep.org/config
ADD dev src/perkeep.org/dev
ADD doc src/perkeep.org/doc
ADD internal src/perkeep.org/internal
ADD pkg src/perkeep.org/pkg
ADD server src/perkeep.org/server
ADD vendor src/perkeep.org/vendor
ADD website src/perkeep.org/website
ADD make.go src/perkeep.org/make.go
ADD VERSION src/perkeep.org/VERSION

WORKDIR $GOPATH/src/perkeep.org
RUN go run make.go --sqlite=true -v

FROM alpine:3.10.2 as runner

RUN apk update
RUN apk --no-cache add tini=0.18.0-r0 su-exec=0.2-r0 sqlite-dev ca-certificates
RUN update-ca-certificates

RUN adduser -D keepy

WORKDIR /perkeep
COPY --chown=root:root entrypoint.sh .
COPY --chown=root:keepy --from=builder /go/bin/pk* ./bin/
COPY --chown=root:keepy --from=builder /go/bin/perkeepd ./bin
COPY --chown=root:keepy --from=builder /go/bin/publisher ./bin
COPY --chown=root:keepy --from=builder /go/bin/scancab ./bin
COPY --chown=root:keepy --from=builder /go/bin/scanningcabinet ./bin

ENV PATH /perkeep/bin:$PATH
ENV CAMLI_CONFIG_DIR /etc/perkeep

EXPOSE 80 443 3179 8080

ENTRYPOINT ["tini", "--", "/perkeep/entrypoint.sh"]
CMD ["server"]
