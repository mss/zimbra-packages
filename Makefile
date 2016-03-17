all: world/all

clean: world/clean

world: all

world/%:
	$(MAKE) -C world/any $@
