# sparc-linux-toolchain
Use [buildroot](https://buildroot.org/) to build a basic SPARC Linux GNU C/++ toolchain and package it for Debian/Ubuntu.

All SPARC GNU tools are prefixed with `sparc-linux`. ie, `sparc-linux-gcc`, `sparc-linux-as`, `sparc-linux-ld`, etc.

SPARC executables can be executed using the `sparcexec` command. This requires a `qemu-sparc-static`.
```sh
# For example...
$ printf '#include <stdio.h>\nint main(void) { puts("Hello, World!"); }' > hello.c
$ sparc-linux-gcc hello.c -o hello
$ sparcexec hello
Hello, World!
```

## Building
Before building anything, you will need to install [buildroot's dependencies](https://buildroot.org/downloads/manual/manual.html#requirement-mandatory). Buildroot also requires that you have no whitespace characters in your PATH.

### For Debian/Ubuntu
Building for Debian/Ubuntu requires dpkg-dev.

```sh
make debian
```
This will build the toolchain and package it for Debian/Ubuntu systems. The resulting deb package will be named `sparc-linux-toolchain_10.4.0-1.deb`.


### Just The Toolchain
```sh
make toolchain
```
This will build the toolchain with buildroot and create a standalone copy in the local `opt/` directory, which you can then copy into your system `/opt`.
