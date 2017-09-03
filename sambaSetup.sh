#!/bin/ash

#
# 05/21/2016
#add force create mode and force create mode
#This is for linux client
#

genSambaGlobal(){
local uchar="$1" dchar="$2" dproxy="${3:-No}" wins="${4:-Yes}" hostallow="$5" \
guestAcc="${6:-nobody}" badUser="${7:-bad user}" loadP="${8:-No}" pName="${9:-/dev/null}" \
disspoolss="${10:-Yes}" pIng="${11:-bsd}" file=$SAMBACONF

echo "[global]" > $file #replace file
echo -e "\tidmap config * : backend = tdb">>$file
[ "$uchar" ] && echo -e "\tunix charset=$uchar">>$file
[ "$dchar" ] && echo -e "\tdos charset=$dchar">>$file
[ "$dproxy" ] && echo -e "\tdns proxy=$dproxy">>$file
[ "$wins" ] && echo -e "\twins support=$wins">>$file
[ "$hostallow" ] && echo -e "\thosts allow=$hostallow">>$file
[ "$guestAcc" ] && echo -e "\tguest account=$guestAcc">>$file
[ "$badUser" ] && echo -e "\tmap to guest=$badUser">>$file
[ "$loadP" ] && echo -e "\tload printers=$loadP">>$file
[ "$pName" ] && echo -e "\tprintcap name=$pName">>$file
[ "$disspoolss" ] && echo -e "\tdisable spoolss=$disspoolss">>$file
[ "$pIng" ] && echo -e "\tprinting=$pIng">>$file
echo -e "\n">>$file
}

genShare(){
local share="$1" sharepath="$2" fUser="$3" fGrp="$4" vUsers="$5" rOnly="$6" cMask="$7" dMask="$8" fcMask="$9" fdMask="$10" guestOk="$11" cmt="$12" file=$SAMBACONF
[ "$share" -a "$sharepath" ] && echo -e "[$share]\n\tpath=$sharepath">>$file || exit 1
[ "$cmt" ] && echo -e "\tcomment=$cmt">>$file
[ "$fUser" ] && echo -e "\tforce user=$fUser">>$file
[ "$fGrp" ] && echo -e "\tforce group=$fGrp">>$file
[ "$vUsers" ] && echo -e "\tvalid users=$vUsers">>$file
[ "$vGrps" ] && echo -e "\tvalid groups=$vGrps">>$file
[ "$rOnly" ] && echo -e "\tread only=$rOnly">>$file
[ "$cMask" ] && echo -e "\tcreate mask=$cMask">>$file
[ "$dMask" ] && echo -e "\tdirectory mask=$dMask">>$file
[ "$fcMask" ] && echo -e "\tforce directory mode=$fcMask">>$file
[ "$fdMask" ] && echo -e "\tforce create mode=$fdMask">>$file
[ "$guestOk" ] && echo -e "\tguest ok=$guestOk">>$file
echo -e "\n">>$file
}

genUser(){
local user="$1" pass="$2" grpname="$3"
if [ "$user" -a "$pass" ];then
	if [ "$grpname" ];then 
		[ $(getent group $grpname | awk -F : '{print $1}') ] || addgroup $grpname
		echo $pass | tee - | adduser -h /dev/null -G $grpname $user
	else
		echo $pass | tee - | adduser -h /dev/null $user		
	fi
	
	echo $pass | tee - | smbpasswd -s -a $user
fi
}


IFS=:
touch $SAMBACONF
while getopts "g:s:u:" f
do
	case "$f" in
		g) eval genSambaGlobal $OPTARG;;
		s) eval genShare $OPTARG;;
		u) eval genUser $OPTARG;;
		\?) echo "help";;
	esac
done
shift $(($OPTIND-1))

smbpasswd -an nobody
exec smbd -FS < /dev/null
