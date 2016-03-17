PKG_ROOT := $(shell pwd)

include $(PKG_ROOT)/../../package.def

pname_lc := world-deb
zname := zimbra-$(pname_lc)
zspec := $(pname_lc).spec

PACKAGES := $(shell grep -e ^zimbra/ -e ^thirdparty/ $(THIRDPARTY_ROOT)/build-order | grep -F -v -f $(THIRDPARTY_ROOT)/build-skip)

.PHONY: all clean build setup world world/% zimbra/% thirdparty/% pre/% pre/all post/% post/all post/build
.NOTPARALLEL: zimbra/% thirdparty/%

all: build

build: setup build_$(PKG_EXT)

setup:
	$(MKDIR) $(PLATFORM_DIR)

clean:
	$(generic-clean)


world: world/all

world/%:
	$(MAKE) $(addsuffix /$(notdir $@),$(PACKAGES))


zimbra/% thirdparty/%: setup
	$(MAKE) do/$(notdir $@) \
		MAKE_PACKAGE_NAME=zimbra-$(notdir $(patsubst %/,%,$(dir $@))) \
		MAKE_PACKAGE_DIR=$(THIRDPARTY_ROOT)/$(dir $@) \
		MAKE_PACKAGE_PLATFORM_DIR=$(BUILD_ROOT)/$(dir $@)/build/$(BUILD_PLATFORM) \
		MAKE_TARGET_FLAG_FILE=$(BUILD_ROOT)/$(dir $@)/build/$(BUILD_PLATFORM)/make-$(notdir $@).flag \
		MAKE_TARGET=$(notdir $@)

do/%:
	$(MAKE) pre/$(MAKE_TARGET)
	test -f $(MAKE_TARGET_FLAG_FILE) || \
		$(MAKE) -C $(MAKE_PACKAGE_DIR) $(MAKE_TARGET)
	$(MAKE) post/$(MAKE_TARGET)

post/build: $(PLATFORM_DIR)/Packages

$(PLATFORM_DIR)/Packages: $(MAKE_PACKAGE_PLATFORM_DIR)/Packages
	$(CD) $(dir $@)/.. && \
		dpkg-scanpackages $(BUILD_PLATFORM) > $(BUILD_PLATFORM)/$(notdir $@).new
	$(MV) $@.new $@
	sudo apt-get update -qq

$(MAKE_PACKAGE_PLATFORM_DIR)/Packages: $(MAKE_PACKAGE_PLATFORM_DIR)/*.deb
	$(MKDIR) $(PLATFORM_DIR)/pool/$(MAKE_PACKAGE_NAME)
	$(CP) -va $^ $(PLATFORM_DIR)/pool/$(MAKE_PACKAGE_NAME)
	$(CD) $(dir $@) && dpkg-scanpackages . > $(notdir $@).new
	$(MV) $@.new $@

post/all: post/build
	touch $(MAKE_TARGET_FLAG_FILE)

post/% pre/%:
	$(NOOP)
