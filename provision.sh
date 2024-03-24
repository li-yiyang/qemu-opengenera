#!/bin/bash

set -e

SOURCES=/tmp/genera # change this by demand
PFILES=$SOURCES

# mount genera files
# mkdir -pv $SOURCES
# mount -v -L cidata $SOURCES

echo "install base packages"
apt-get update && apt-get install -y curl vnc4server nfs-common nfs-kernel-server inetutils-inetd ratpoison xterm

if [ ! -d "/opt/symbolics" ]; then
  echo "expand opengenera"
  cd /opt; tar xfz $SOURCES/opengenera2.tar.gz
fi

# if [[ ! -f "$SOURCES/snap4.tar.gz" ]]; then
#   echo "download snap4"
#   cd $SOURCES; curl -O http://www.unlambda.com/download/genera/snap4.tar.gz
# fi

if [ ! -d "/opt/snap4" ]; then
  echo "expand snap4"
  cd /opt; tar xfz $SOURCES/snap4.tar.gz
fi

echo "/etc/inetd.conf"
cp $PFILES/inetd.conf /etc/inetd.conf
chmod 0644 /etc/inetd.conf

echo "bounce inetd"
/etc/init.d/inetutils-inetd restart

echo "set hostname"
echo 'genera-host' > /etc/hostname; hostname genera-host

echo "/etc/hosts"
cp $PFILES/hosts /etc/hosts
chmod 0644 /etc/hosts

echo "/etc/exports"
cp $PFILES/exports /etc/exports
chmod 0644 /etc/exports

echo "bounce nfs"
/etc/init.d/nfs-kernel-server restart

echo "/opt/snap4/.VLM"
cp $PFILES/dotVLM /opt/snap4/.VLM
chmod 0644 /opt/snap4/.VLM

if [ ! -d "/var/lib/symbolics" ]; then
  echo "configure og2 image"
  SDIR=/var/lib/symbolics
  cp -R /opt/snap4 $SDIR; 
  cp -R /opt/symbolics/sys.sct $SDIR;
  chmod a+x $SDIR/genera
  mkdir $SDIR/rel-8-5; 
  ln -s $SDIR/sys.sct $SDIR/rel-8-5/sys.sct; 
  cp $PFILES/run-genera $SDIR;
  ln -s $SDIR/run-genera /usr/local/bin
  cp $PFILES/restart-genera $SDIR
  ln -s $SDIR/restart-genera /usr/local/bin
fi

echo "/root/.vnc"
mkdir -p /root/.vnc

cp $PFILES/vncpasswd /root/.vnc/passwd
chmod 0600 /root/.vnc/passwd

cp $PFILES/vncxstartup /root/.vnc/xstartup
chmod 0755 /root/.vnc/xstartup

echo "allow global write to genera files"
chmod ugo+w -R /var/lib/symbolics/sys.sct

echo "clear vnc.pid on startup"
echo 'rm -f /root/.vnc/genera-host:1.pid' > /etc/rc.local
echo 'HOME=/root vncserver -geometry 1150x900' >> /etc/rc.local

echo "start opengenera under vnc"
if [ ! -f "/root/.vnc/genera-host:1.pid" ]; then
  HOME=/root vncserver -geometry 1150x900
fi
