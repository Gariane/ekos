KERNEL_BINARY = $(BUILD_DIR)/kernel.bin

KERNEL_CXXFLAGS = -ffreestanding -fno-rtti -fno-exceptions -mno-red-zone -mno-mmx -mno-sse -mno-sse2 -c
KERNEL_LDFLAGS = -n -nostdlib -ffreestanding -mno-red-zone -lgcc

KERNEL_SOURCES = $(wildcard kernel/*.cc)
KERNEL_ASM_SOURCES = $(wildcard kernel/arch/$(BUILD_ARCH)/*.asm)

KERNEL_OBJ = $(patsubst %.asm, $(BUILD_DIR)/%.o, $(KERNEL_ASM_SOURCES)) \
			 $(patsubst %.cc, $(BUILD_DIR)/%.o, $(KERNEL_SOURCES))

$(BUILD_DIR)/kernel/%.o : kernel/%.cc
	$(CREATE_DIR)
	
	$(info [KERNEL] building $<)
	@$(CXX) $(CXXFLAGS) $(KERNEL_CXXFLAGS) -o $@ $<

$(BUILD_DIR)/kernel/%.o : kernel/%.asm
	$(CREATE_DIR)

	$(info [KERNEL] building $<)
	@$(AS) $(ASFLAGS) -o $@ $<

$(KERNEL_BINARY) : $(KERNEL_OBJ)
	$(CREATE_DIR)

	$(info [KERNEL] linking $@)
	@$(CXX) $(LDFLAGS) $(KERNEL_LDFLAGS) -T kernel/arch/$(BUILD_ARCH)/linker.ld -o $@ $^

