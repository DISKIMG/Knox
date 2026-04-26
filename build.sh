#!/bin/bash
set -e

mkdir -p bin

nasm -f elf32 init/arch/x86_64/header.S -o bin/header.o

CFLAGS="-m32 -ffreestanding -fno-pie -fno-stack-protector -fno-builtin -nostdlib"
INCLUDE_PATHS="-I./drv -I./init -I./lib"

SOURCES=$(find . -name "*.c")
OBJECTS="bin/header.o "

for src in $SOURCES; do
    obj="bin/$(echo $src | sed 's/\//_/g' | sed 's/\.c/\.o/')"
    gcc $CFLAGS $INCLUDE_PATHS -c $src -o $obj
    OBJECTS+="$obj "
done

ld -m elf_i386 -T linker.ld $OBJECTS -o bin/knkrnl.elf

mkdir -p isodir/boot/grub
cp bin/knkrnl.elf isodir/boot/knkrnl.elf
cp grub.cfg isodir/boot/grub/grub.cfg
grub-mkrescue -o knox.iso isodir

echo "Done!"
qemu-system-x86_64 -cdrom knox.iso