#!/bin/bash
if [[ ! -e  ~/Downloads/SR3-SuperSU-v2.82-SR3-20170813133244.zip ]]
then
    echo "~/Downloads/SR3-SuperSU-v2.82-SR3-20170813133244.zip not found"
    echo "Download SuperSU from https://download.chainfire.eu/1122/SuperSU/SR3-SuperSU-v2.82-SR3-20170813133244.zip?retrieve_file=1"
    exit
fi


TMPDIR=`mktemp -d`
cd $TMPDIR
mkdir su

function cleanup(){
    rm -fr $TMPDIR
    exit 1
}
trap "cleanup" SIGINT SIGTERM

unzip ~/Downloads/SR3-SuperSU-v2.82-SR3-20170813133244.zip -d su

if [[ ! -e  /var/lib/anbox/android.img_orig ]]
then
    sudo cp /var/lib/anbox/android.img{,_orig}
fi
unsquashfs /var/lib/anbox/android.img_orig

#mkdir squashfs-root/system/app/SuperSU
mkdir squashfs-root/system/bin/.ext

#cp su/common/Superuser.apk squashfs-root/system/app/SuperSU/SuperSU.apk
cp su/common/install-recovery.sh squashfs-root/system/etc/install-recovery.sh
cp su/common/install-recovery.sh squashfs-root/system/bin/install-recovery.sh
cp su/x64/su squashfs-root/system/xbin/su
cp su/x64/su squashfs-root/system/bin/.ext/.su
cp su/x64/su squashfs-root/system/xbin/daemonsu
cp su/x64/supolicy squashfs-root/system/xbin/supolicy
cp su/x64/libsupol.so squashfs-root/system/lib64/libsupol.so
cp squashfs-root/system/bin/app_process64 squashfs-root/system/bin/app_process_init
cp squashfs-root/system/bin/app_process64 squashfs-root/system/bin/app_process64_original
cp squashfs-root/system/xbin/daemonsu squashfs-root/system/bin/app_process
cp squashfs-root/system/xbin/daemonsu squashfs-root/system/bin/app_process64

#chmod 0755 squashfs-root/system/app/SuperSU/SuperSU.apk
chmod 0755 squashfs-root/system/etc/install-recovery.sh
chmod 0755 squashfs-root/system/bin/install-recovery.sh
chmod 0755 squashfs-root/system/xbin/su
chmod 0755 squashfs-root/system/bin/.ext/.su
chmod 0755 squashfs-root/system/xbin/daemonsu
chmod 0755 squashfs-root/system/xbin/supolicy
chmod 0755 squashfs-root/system/lib64/libsupol.so
chmod 0755 squashfs-root/system/bin/app_process_init
chmod 0755 squashfs-root/system/bin/app_process64_original
chmod 0755 squashfs-root/system/bin/app_process
chmod 0755 squashfs-root/system/bin/app_process64

#sudo chown 0:0 squashfs-root/system/app/SuperSU/SuperSU.apk
sudo chown 0:0 squashfs-root/system/etc/install-recovery.sh
sudo chown 0:0 squashfs-root/system/bin/install-recovery.sh
sudo chown 0:0 squashfs-root/system/xbin/su
sudo chown 0:0 squashfs-root/system/bin/.ext/.su
sudo chown 0:0 squashfs-root/system/xbin/daemonsu
sudo chown 0:0 squashfs-root/system/xbin/supolicy
sudo chown 0:0 squashfs-root/system/lib64/libsupol.so
sudo chown 0:0 squashfs-root/system/bin/app_process_init
sudo chown 0:0 squashfs-root/system/bin/app_process64_original
sudo chown 0:0 squashfs-root/system/bin/app_process
sudo chown 0:0 squashfs-root/system/bin/app_process64

mksquashfs squashfs-root android.img -b 131072 -comp xz -Xbcj ia64

sudo cp android.img /var/lib/anbox/android.img

sudo systemctl restart anbox-container-manager.service
systemctl --user restart anbox-session-manager.service

echo "rm -fr $TMPDIR to cleanup"
