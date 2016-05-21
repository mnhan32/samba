FROM docker.io/alpine:3.3
MAINTAINER Menghan Ho <mnhan32@gmail.com>
RUN apk add --update samba samba-common-tools
COPY sambaSetup.sh /samba/
EXPOSE 139 445
EXPOSE 137/UDP 138/UDP
ENTRYPOINT ["/samba/sambaSetup.sh"]
