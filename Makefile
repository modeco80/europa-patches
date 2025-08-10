# Top-level Makefile. Builds all patches

TOP=$(shell pwd)
ARMIPS=armips

define makeone
	$(MAKE) -C $(1) TOP=$(TOP) ARMIPS=$(ARMIPS) REGION=usa
endef

define cleanone
	$(MAKE) -C $(1) TOP=$(TOP) ARMIPS=$(ARMIPS) REGION=usa clean
endef

define doallpatches
	 $(call $1,hostfs_sf)
endef

all:
	$(call doallpatches,makeone)

clean:
	$(call doallpatches,cleanone)

# copy built patches to emulator
# e.g: make PCSX2_DIR=/home/lily/.config/PCSX2
copy:
	cp -v patches/*.pnach $(PCSX2_DIR)/cheats/
