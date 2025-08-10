# rules.mk

PNACH_FILENAME = $(PNACH_CRC).$(PNACH_NAME).pnach

all: $(PNACH_FILENAME)

clean: clean-user
	rm -f $(PNACH_FILENAME)

$(PNACH_FILENAME): $(PNACH_JSON) $(DEPS)
	$(TOP)/pnach_utils/output_pnach.py $(PNACH_JSON) $@
	cp $@ $(TOP)/patches

