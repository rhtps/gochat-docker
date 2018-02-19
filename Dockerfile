FROM centos:7

MAINTAINER Kenneth D. Evensen <kevensen@redhat.com>

ENV GOPATH=/opt/gopath/
ENV GOBIN=$GOPATH/bin
ENV GOROOT=/opt/go 
ENV PATH=$PATH:/opt/go/bin:$GOBIN

RUN yum clean all && \
    yum update -y && \
    yum install -y --setopt=tsflags=nodocs \
                   git-bzr \
                   bzr \
                   tar && \
    yum clean all && \ 
    rm -rf /var/cache/yum/*

RUN useradd 1001
EXPOSE 8080

RUN cd /opt && \
    curl -o go1.6.2.linux-amd64.tar.gz \
    https://storage.googleapis.com/golang/go1.6.2.linux-amd64.tar.gz && \
    tar -xvf go1.6.2.linux-amd64.tar.gz

RUN go get -insecure github.com/rhtps/gochat

RUN chown -R 1001:1001 $GOPATH
USER 1001
WORKDIR $GOPATH/src/github.com/rhtps/gochat/
ENTRYPOINT ["gochat", "-host=0.0.0.0:8080", "-callBackHost=http://gochat:8080", "-templatePath=$GOPATH/src/github.com/rhtps/gochat/templates/", "-avatarPath=$GOPATH/src/github.com/rhtps/gochat/avatars", "-htpasswdPath=$GOPATH/src/github.com/rhtps/gochat/htpasswd"]
