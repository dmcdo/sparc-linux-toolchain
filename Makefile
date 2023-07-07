BUILDROOT_VERSION = 2023.02.2
REVISION = 1
DPKG_NAME = "$(BUILDROOT_VERSION)-$(REVISION)"
MAINTAINER = "$(shell git config user.name) \<$(shell git config user.email)\>"

default: toolchain

buildroot.tar.gz:
	wget https://buildroot.org/downloads/buildroot-$(BUILDROOT_VERSION).tar.gz -O buildroot.tar.gz

buildroot/: buildroot.tar.gz
	tar xf buildroot.tar.gz
	mv buildroot-$(BUILDROOT_VERSION)/ buildroot/
	cp .config buildroot/

buildroot: buildroot/

buildroot/output/images/sparc-buildroot-linux-uclibc_sdk-buildroot.tar.gz: buildroot
	cd buildroot/ && make sdk
	cp buildroot/output/images/sparc-buildroot-linux-uclibc_sdk-buildroot.tar.gz .

toolchain: buildroot/output/images/sparc-buildroot-linux-uclibc_sdk-buildroot.tar.gz

sparc-linux-toolchain.deb: toolchain
	mkdir -p sparc-linux-toolchain_$(DPKG_NAME)
	mkdir -p sparc-linux-toolchain_$(DPKG_NAME)/opt
	mkdir -p sparc-linux-toolchain_$(DPKG_NAME)/usr/bin
	mkdir -p sparc-linux-toolchain_$(DPKG_NAME)/DEBIAN

	echo "Package: sparc-linux-toolchain"                   >  sparc-linux-toolchain_$(DPKG_NAME)/DEBIAN/control
	echo "Version: $(DPKG_NAME)"                            >> sparc-linux-toolchain_$(DPKG_NAME)/DEBIAN/control
	echo "Architecture: $(shell dpkg --print-architecture)" >> sparc-linux-toolchain_$(DPKG_NAME)/DEBIAN/control
	echo "Depends: qemu-user-static (>= 1.3.1)"             >> sparc-linux-toolchain_$(DPKG_NAME)/DEBIAN/control
	echo "Maintainer: $(MAINTAINER)"                        >> sparc-linux-toolchain_$(DPKG_NAME)/DEBIAN/control
	echo "Description: SPARC Linux cross toolchain (GNU)"   >> sparc-linux-toolchain_$(DPKG_NAME)/DEBIAN/control

	tar xf sparc-buildroot-linux-uclibc_sdk-buildroot.tar.gz -C sparc-linux-toolchain_$(DPKG_NAME)/opt
	cd sparc-linux-toolchain_$(DPKG_NAME)/usr/bin && ln -s ../../opt/sparc-buildroot-linux-uclibc_sdk-buildroot/bin/sparc-linux-* .
	cp sparcexec sparc-linux-toolchain_$(DPKG_NAME)/usr/bin/sparcexec
	dpkg-deb --build sparc-linux-toolchain_$(DPKG_NAME)
	mv sparc-linux-toolchain_$(DPKG_NAME).deb sparc-linux-toolchain.deb

debian: sparc-linux-toolchain.deb

clean:
	rm -f sparc-linux-toolchain*.deb
	rm -rf sparc-linux-toolchain_*/
	rm -f sparc-buildroot-linux-uclibc_sdk-buildroot.tar.gz
	rm -f buildroot.tar.gz
	rm -rf buildroot/

install:
	tar xf sparc-buildroot-linux-uclibc_sdk-buildroot.tar.gz -C /opt
	cd /usr/bin && ln -s ../../opt/sparc-buildroot-linux-uclibc_sdk-buildroot/bin/sparc-linux-* .
	cp sparcexec /usr/bin/sparcexec

uninstall:
	rm -rf /opt/sparc-buildroot-linux-uclibc_sdk-buildroot
	rm /usr/bin/sparcexec
	rm /usr/bin/sparc-linux-*
