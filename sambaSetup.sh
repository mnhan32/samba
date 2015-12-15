#!/bin/ash
genSambaGlobal(){
local uchar="$1" dchar="$2" dproxy="${3:-No}" wins="${4:-Yes}" hostallow="$5" \
guestAcc="${6:-nobody}" badUser="${7:-bad user}" loadP="${8:-No}" pName="${9:-/dev/null}" \
disspoolss="${10:-Yes}" pIng="${11:-bsd}" file=$SAMBACONF

echo "[global]" > $file #replace file
echo -e "\tidmap config * : backend = tdb">>$file
[ -n "$uchar" ] && echo -e "\tunix charset=$uchar">>$file
[ -n "$dchar" ] && echo -e "\tdos charset=$dchar">>$file
[ -n "$dproxy" ] && echo -e "\tdns proxy=$dproxy">>$file
[ -n "$wins" ] && echo -e "\twins support=$wins">>$file
[ -n "$hostallow" ] && echo -e "\thosts allow=$hostallow">>$file
[ -n "$guestAcc" ] && echo -e "\tguest account=$guestAcc">>$file
[ -n "$badUser" ] && echo -e "\tmap to guest=$badUser">>$file
[ -n "$loadP" ] && echo -e "\tprinting=$loadP">>$file
[ -n "$pName" ] && echo -e "\tprintcap name=$pName">>$file
[ -n "$disspoolss" ] && echo -e "\tdisable spoolss=$disspoolss">>$file
[ -n "$pIng" ] && echo -e "\tprinting=$pIng">>$file

}

genShare(){
local share="$1" sharepath="$2" fUser="$3" fGrp="$4" vUsers="$5" vGrps="$6" rOnly="$7" cMask="$8" dMask="$9" gOk="$10" $cmt="$11" file=$SAMBACONF
[ -n "$share" -a -n "$sharepath" ] && echo -e "[$share]\n\tpath=$sharepath">>$file || exit 1
[ -n "$cmt" ] && echo -e "\tcomment=$cmt">>$file
[ -n "$fUser" ] && echo -e "\tforce user=$fUser">>$file
[ -n "$fGrp" ] && echo -e "\tforce group=$fGrp">>$file
[ -n "$vUsers" ] && echo -e "\tvalid users=$vUsers">>$file
[ -n "$vGrps" ] && echo -e "\tvalid groups=$vGrps">>$file
[ -n "$vUsers" ] && echo -e "\tvalid users=$vUsers">>file
[ -n "$vGrps" ] && echo -e "\tvalid groups=$vGrps">>file
[ -n "$rOnly" ] && echo -e "\tread only=$rOnly">>file
[ -n "$cMask" ] && echo -e "\tcreate mask=$cMask">>file
[ -n "$dMask" ] && echo -e "\tdirectory mask=$dMask">>file
[ -n "$gOK" ] && echo -e "\tguest ok=$gOk">>file
}

genUser(){
local user="$1" pass="$2"
echo $pass | tee - | adduser -h /dev/null $user && \
echo $pass | tee - | smbpasswd -s -a $user
}

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
