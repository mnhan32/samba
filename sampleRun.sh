#!/bin/bash
#
#
#Use this script to run samba docker
#The docker only contain alpine:latest and samba
#with sambaSetup.sh embed, you can config smb.conf or 
#create new user on docker without rebuild or commit docker
#password is plaintext(bad...), but I don't know how to do it in more secured way.
#There is no usage or doc for sambSetup.sh, maybe next version
#
/usr/bin/docker run -d --name sambaServer \#setup name, running in detach mode
--env SAMBACONF=/etc/samba/smb.conf \#define env for samba
--env TIMEZONE="Asia/Taipei" \#define timezone
-p 139:139 -p 445:445 -p 137:137 -p 138:138 \#expose port
-v /serverSide/pathA:/dockerSide/pathA \#use -v to expose server folder to docker
-v /serverSide/pathB:/dockerSide/pathB \#anthoer folder
mnhan32/samba:1.5 \# define docker to use
-g "UTF8:CP950:No:Yes:192.168.1.:nobody:'bad user':No:/dev/null:Yes:bsd" \#-g for [global] setup, check sambaSetup.sh to usage
-s "Media:/samba/media:nobody:nogroup:'':No:0777:0777:Yes:'Media Center'" \#-s for folder setup. this one set to guest, 
-s "Backup:/samba/backup:'':'':@sambaSel:No:0777:0777:'':Backup" \#this one only allowed valid users
-u "usr1:1:sambaSel" \# -u add user to linux and samba,  "usrname:password:groupname"
-u "usr2:1:sambaSel" \
-u "usr3:1:sambaSel"
