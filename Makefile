
PACKAGE_NAME = luajit-lgsl
VERSION = 0.1
LUA = luajit

DEB_PACKAGE = $(PACKAGE_NAME)_$(VERSION)-1_$(ARCH).deb

ARCH := $(shell dpkg-architecture -qDEB_HOST_ARCH)

PREFIX = /usr/local
DOCDIR = doc
DEBIAN = debian_build$(PREFIX)

LUA_SRC = bspline.lua check.lua complex.lua csv.lua eigen.lua fft.lua \
	gsl-check.lua gsl.lua integ.lua iter.lua linfit.lua \
	matrix.lua nlinfit.lua ode.lua randist.lua rnd.lua \
	rng.lua sf.lua sort.lua template.lua vegas.lua

LUA_TEMPLATES_SRC = gauss-kronrod-x-wgs.lua.in lmfit.lua.in \
	ode-defs.lua.in qag.lua.in qng.lua.in rk4.lua.in rk8pd.lua.in \
	rkf45.lua.in rkf45vec.lua.in rnd-defs.lua.in sf-defs.lua.in \
	vegas-defs.lua.in

debian: $(DEB_PACKAGE)

$(DEB_PACKAGE):
	@echo "cleaning build directory"
	@rm -fr debian_build
	@rm -fr $(DEB_PACKAGE)
	@echo "creating debian package $(DEB_PACKAGE)"
	@mkdir -p $(DEBIAN)/share/lua/5.1/lgsl
	@mkdir -p $(DEBIAN)/share/lua/5.1/lgsl/templates
	@cp $(LUA_SRC:%.lua=lgsl/%.lua) $(DEBIAN)/share/lua/5.1/lgsl
	@cp lgsl.lua $(DEBIAN)/share/lua/5.1/
	@cp $(LUA_TEMPLATES_SRC:%.lua.in=lgsl/templates/%.lua.in) $(DEBIAN)/share/lua/5.1/lgsl/templates
	@fakeroot bash debian/build.sh $(PACKAGE_NAME) $(VERSION) $(LUA)

install:
	@echo "copying files in $(PREFIX)/share/lua/5.1/lgsl"
	@mkdir -p $(PREFIX)/share/lua/5.1/lgsl
	@mkdir -p $(PREFIX)/share/lua/5.1/lgsl/templates
	@cp $(LUA_SRC:%.lua=lgsl/%.lua) $(PREFIX)/share/lua/5.1/lgsl
	@cp lgsl.lua $(PREFIX)/share/lua/5.1/
	@cp $(LUA_TEMPLATES_SRC:%.lua.in=lgsl/templates/%.lua.in) $(PREFIX)/share/lua/5.1/lgsl/templates

clean:
	@echo "cleaning"
	@rm -fr debian_build
	@rm -fr $(DEB_PACKAGE)

test:
	$(LUA) test-output.lua

doc: doc-html

doc-html:
	cd $(DOCDIR) && $(MAKE) html

.PHONY: clean debian install test doc
