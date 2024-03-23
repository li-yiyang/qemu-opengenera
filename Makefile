# ubuntu requires packages git make rubygems libxml2-dev libxslt-dev zlib1g-dev virtualbox

# most of these targets are pseudotargets, and make will always think they are out of date.
# bash conditionals are liberally applied to avoid rebuilding things too often.

SSH_PORT=2333
VNC_PORT=5902

CLOUD_IMG_LINK="https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img"

all: qemu-install

clean:
	rm -rf img/*
	rm snap4.tar.gz
	rm 

qemu-install: img/genera.img img/cidata.iso
	qemu-system-x86_64 -m 4G -hda img/genera.img -cdrom img/cidata.iso -device e1000,netdev=net0 -netdev user,id=net0,hostfwd=tcp::$(SSH_PORT)-:22,hostfwd=tcp::$(VNC_PORT)-:5901 -nographic

img/genera.img:
	curl -L $(CLOUD_IMG_LINK) -o $@

img/cidata.iso: meta-data user-data provision.sh snap4.tar.gz opengenera2.tar.gz provisioning/*
	mkisofs -output $@ -volid cidata -joliet -rock $^

# fake the snap4.tar.gz
snap4.tar.gz: snap/Genera-8-5.vlod snap/VLM_debugger snap/genera
	tar cjf $@ snap

# use a version with NFSv3 support
# see more in http://www.jachemich.de/vlm/genera.html
snap/Genera-8-5.vlod:
	curl -L "http://www.jachemich.de/vlm/distribution.vlod" -o $@

# fake the opengenera2.tar.gz
# see more in https://archives.loomcom.com/genera/genera-install.html
opengenera2.tar.gz:
	curl -L "https://archives.loomcom.com/genera/var_lib_symbolics.tar.gz" -o $@

snap/genera:
	curl -L "http://www.jachemich.de/vlm/genera" -o $@

snap/VLM_debugger:
	curl -L "https://archives.loomcom.com/genera/worlds/VLM_debugger" -o $@
