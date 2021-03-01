BUILD_ARCH = x86_64
BUILD_DIR = $(shell pwd)/build

PRODUCT_DIR = $(shell pwd)/products
PRODUCT = $(PRODUCT_DIR)/ekos.img

CXX = $(HOME)/opt/cross_x64/bin/x86_64-elf-g++
CXXFLAGS = -std=c++20 -MD -ffreestanding -Wold-style-cast -Wall -Wextra -Werror -fno-rtti -fno-exceptions
LDFLAGS = -nostdlib -ffreestanding -lgcc

AS = nasm
ASFLAGS = -f elf64

MKRESCUE = $(HOME)/opt/grub/bin/grub-mkrescue

CREATE_DIR = @mkdir -p $(@D)

include kernel/build.mk

.PHONY: all
all : $(PRODUCT)

$(PRODUCT) : $(KERNEL_BINARY)
	$(CREATE_DIR)

	$(info [GENERAL] Creating bootable iso)
	@mkdir -p $(BUILD_DIR)/iso/boot/grub
	@cp grub.cfg $(BUILD_DIR)/iso/boot/grub
	@cp $< $(BUILD_DIR)/iso/boot
	@$(MKRESCUE) -o $@ $(BUILD_DIR)/iso 2>/dev/null

.PHONY: run
run : $(PRODUCT)
	$(info [GENERAL] Running qemu)
	@qemu-system-x86_64 -cdrom $(PRODUCT) >/dev/null

.PHONY: clean
clean:
	$(RM) -r $(BUILD_DIR)
	$(RM) -r $(PRODUCT_DIR)
 
