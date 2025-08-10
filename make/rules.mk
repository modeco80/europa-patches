# rules.mk


PNACH_FILENAME = $(PNACH_CRC).$(PNACH_NAME).pnach

all: $(PNACH_FILENAME)

clean: clean-user
	rm -f $(PNACH_FILENAME)

$(PNACH_FILENAME): $(PNACH_JSON) $(DEPS)
	$(TOP)/pnach_utils/output_pnach.py $(PNACH_JSON) $@
	cp $@ $(TOP)/patches

# Use to generate an ASM rule
# $1 = source file
# $2 = A binary product of this ASM file
define make_asm
$(2): $(1)
	armips -sym $(dir $(2))/$(basename $(notdir $(1))).sym $(1)
endef