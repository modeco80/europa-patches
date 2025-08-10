# rules.mk

PNACH_FILENAME = $(PNACH_CRC).$(PNACH_NAME).pnach

all: $(PNACH_FILENAME)

clean: clean-user
	rm -f *.bin *.pnach symbols.sym

$(MAIN_BINARY): $(SOURCE_FILE)
	$(ARMIPS) -sym symbols.sym $<

$(PNACH_FILENAME): $(PNACH_JSON) $(MAIN_BINARY)
	$(TOP)/pnach_utils/output_pnach.py $(PNACH_JSON) $@
	cp $@ $(TOP)/patches

