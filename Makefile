default: toolchain

buildroot-2023.02.2.tar.gz:
	wget https://buildroot.org/downloads/buildroot-2023.02.2.tar.gz

buildroot-2023.02.2/: buildroot-2023.02.2.tar.gz
	tar xvf buildroot-2023.02.2.tar.gz

opt/: buildroot-2023.02.2/
	cp .config buildroot-2023.02.2/
	cd buildroot-2023.02.2/ && make toolchain
	mkdir -p opt/sparc-linux-toolchain
	cp -r buildroot-2023.02.2/output/host/* opt/sparc-linux-toolchain

toolchain: opt/

sparc-linux-toolchain_10.4.0-1.deb: toolchain
	mkdir -p sparc-linux-toolchain_10.4.0-1
	cp -r DEBIAN sparc-linux-toolchain_10.4.0-1
	cp -r opt sparc-linux-toolchain_10.4.0-1
	mkdir -p sparc-linux-toolchain_10.4.0-1/usr/bin
	cd sparc-linux-toolchain_10.4.0-1/usr/bin && ln -s ../../opt/sparc-linux-toolchain/bin/sparc-* .
	cp sparcexec sparc-linux-toolchain_10.4.0-1/usr/bin/sparcexec
	dpkg-deb --build sparc-linux-toolchain_10.4.0-1

debian: sparc-linux-toolchain_10.4.0-1.deb

clean:
	rm -f sparc-linux-toolchain_10.4.0-1.deb
	rm -rf sparc-linux-toolchain_10.4.0-1
	rm -rf opt
	rm -rf buildroot-2023.02.2
