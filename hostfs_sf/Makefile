# defaults
TOP ?= ..
ARMIPS ?= armips

REGION ?= usa

# crc for each thing
ifeq ($(REGION),usa)
PNACH_CRC = F32494AC
else
$(error invalid region)
endif

# Set some stuff
PNACH_NAME = hostfs

MAIN_BINARY = obj/$(REGION)/CPS2CDStore_ct.bin
SOURCE_FILE = obj/$(REGION)/hostfs.asm
PNACH_JSON = obj/$(REGION)/patch.json

include $(TOP)/make/rules.mk

obj/:
	mkdir -p $@

obj/$(REGION)/: obj/
	mkdir -p $@

clean-user:
	rm -rf obj/
	
$(SOURCE_FILE): obj/$(REGION)/ regions/$(REGION).inc generate_asm.py thunk_header.jinja2 thunk.jinja2
	./generate_asm.py $@

$(PNACH_JSON): obj/$(REGION)/ regions/$(REGION).inc make_patch_json.py
	./make_patch_json.py $(REGION) > $@

$(MAIN_BINARY): obj/$(REGION)/
