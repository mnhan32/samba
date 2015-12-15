#!/bin/bash
/usr/bin/docker run -d --name sambaServer \
--env SAMBACONF=/etc/samba/smb.conf \
--env TIMEZONE="Asia/Taipei" \
-p 139:139 -p 445:445 -p 137:137 -p 138:138 \
-v /mnt/WD_RAID1_RED_3T/Media:/samba/media \
-v /mnt/WD_RAID1_RED_3T/STOCKS:/samba/stock \
-v /mnt/WD_RAID1_RED_3T/Project:/samba/project \
-v /mnt/WD_RAID1_RED_3T/Downloads/Completed:/samba/download/complete \
-v /mnt/WD_RAID1_RED_3T/Downloads/Torrents:/samba/download/torrent \
-v /mnt/Transfer:/samba/transfer \
-v /mnt/Backup:/samba/backup \
mnhan32/samba:1.5 \
-g "UTF8:CP950:No:Yes:192.168.1.:nobody:'bad user':No:/dev/null:Yes:bsd" \
-s "Media:/samba/media:nobody:nogroup:'':No:0777:0777:Yes:'Media Center'" \
-s "Stocks:/samba/stock:nobody:nogroup:'':No:0777:0777:Yes:Stocks Data" \
-s "Transfer:/samba/transfer:nobody:nogroup:'':No:0777:0777:Yes:Transfer " \
-s "Download:/samba/download/complete:nobody:nogroup:'':Yes:'':'':Yes:Download" \
-s "Torrent:/samba/download/torrent:nobody:nogroup:'':No:0777:0777:Yes:Torrent" \
-s "Backup:/samba/backup:'':'':@sambaSel:No:0777:0777:'':Backup" \
-s "Project:/samba/project:'':'':@sambaSel:No:0777:0777:'':Project" \
-u "hansolo:1:sambaSel" \
-u "han:1:sambaSel" \
-u "hanvm1:1:sambaSel" \
-u "hanvm2:1:sambaSel" \
-u "hanvm3:1:sambaSel" \
-u "hanvm4:1:sambaSel"
