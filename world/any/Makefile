PKG_ROOT := $(shell pwd)

include $(PKG_ROOT)/../../package.def

pname_lc := world-any
zname := zimbra-$(pname_lc)
zspec := $(pname_lc).spec

.PHONY: all clean build setup world

world: world/all

world/%:
	$(MAKE) -C $(PKG_ROOT)/../$(PKG_EXT) $@
