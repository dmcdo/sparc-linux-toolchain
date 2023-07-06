# sparc-linux-toolchain
Use make to build basic a SPARC Linux GNU C/++ toolchain using buildroot and package it for Debian/Ubuntu.

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
### For Debian/Ubuntu
```sh
make debian
```
This will build the toolchain and package it for Debian/Ubuntu systems. The resulting deb package will be named `sparc-linux-toolchain_10.4.0-1.deb`.


### Just The Toolchain
```sh
make toolchain
```
This will build the toolchain with buildroot and create a standalone copy in the local `opt/` directory, which you can then copy into your system `/opt`.
