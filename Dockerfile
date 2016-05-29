FROM rhel7:latest

MAINTAINER Kenneth D. Evensen <kevensen@redhat.com>

ENV GOPATH=/opt/golang/ 
ENV PATH=$PATH:$GOPATH/bin

RUN yum clean all && \
    yum install -y --setopt=tsflags=nodocs \
                   --disablerepo='*' \
                   --enablerepo='rhel-7-server-rpms' \
                   --enablerepo='rhel-7-server-extras-rpms' \
                   --enablerepo='rhel-7-server-optional-rpms' \
                   golang \
                   golang-bin \
                   git-bzr bzr && \
    yum clean all && \ 
    rm -rf /var/cache/yum/*

RUN useradd 1001
EXPOSE 8080

RUN go get github.com/tools/godep && \
    mkdir -p $GOPATH/src/github.com/rhtps && \
    cd $GOPATH/src/github.com/rhtps && \
    git clone https://github.com/rhtps/gochat.git && \
    cd $GOPATH/src/github.com/rhtps/gochat && \
    godep restore github.com/rhtps/gochat && \
    go get github.com/rhtps/gochat
RUN chown -R 1001:1001 $GOPATH
USER 1001

RUN cd $GOPATH/src/github.com/rhtps/gochat/; go install
ENTRYPOINT ["gochat"]
