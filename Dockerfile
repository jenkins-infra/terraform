FROM golang:alpine
MAINTAINER "Jenkins Infra Team <infra@lists.jenkins-ci.org>"

RUN apk add --update git bash

ENV TF_DEV=true
ENV XC_ARCH=amd64

ADD . $GOPATH/src/github.com/hashicorp/terraform/
WORKDIR $GOPATH/src/github.com/hashicorp/terraform
RUN /bin/bash scripts/build.sh

WORKDIR $GOPATH
ENTRYPOINT ["terraform"]
