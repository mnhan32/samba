FROM docker.io/alpine:latest
MAINTAINER Menghan Ho <mnhan32@gmail.com>
RUN apk add --update samba samba-common-tools
COPY sambaSetup.sh /usr/local/bin/
EXPOSE 139/TCP 445/TCP
EXPOSE 137/UDP 138/UDP
ENTRYPOINT ["/usr/local/bin/sambaSetup.sh"]
