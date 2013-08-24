# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_DEPEND="2:2.7"

inherit subversion python

DESCRIPTION="Ago control home automation suite"
HOMEPAGE="http://www.agocontrol.com/"

ESVN_REPO_URI="http://svn.agocontrol.com/svn/agocontrol"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-cpp/yaml-cpp
		dev-libs/jsoncpp
		dev-python/pyyaml
		dev-python/qpid-python
		dev-python/sqlite3dbm
		net-misc/qpid-cpp"
RDEPEND="${DEPEND}"

pkg_setp() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	python_convert_shebangs -r 2 .

	sed -i '\#install devices/agologger#d' Makefile
	sed -i '\#install devices/agoowfs#d' Makefile
	sed -i '\#install -d $(DESTDIR)/etc/opt/agocontrol/owfs#d' Makefile
	rm conf/agoowfs.service
	sed -i '\#install devices/enigma2#d' Makefile
	rm conf/agoenigma2.service
	sed -i '\#install devices/asterisk#d' Makefile
	rm conf/agoasterisk.service
	sed -i '\#install devices/onkyo#d' Makefile
	rm conf/agoiscp.service
	sed -i '\#install devices/zwave#d' Makefile
	sed -i '\#install scripts/convert-zwave-uuid#d' Makefile
	sed -i '\#install -d $(DESTDIR)/etc/opt/agocontrol/uuidmap#d' Makefile
	sed -i '\#install -d $(DESTDIR)/etc/opt/agocontrol/ozw#d' Makefile
	rm conf/agozwave.service
	sed -i '\#install devices/agoknx#d' Makefile
	rm conf/agoknx.service
	sed -i '\#install devices/firmata#d' Makefile
	rm conf/agofirmata.service
	sed -i '\#install devices/rain8net#d' Makefile
	rm conf/agorain8net.service
	sed -i '\#install devices/irtrans_ethernet#d' Makefile
	rm conf/agoirtransethernet.service
	sed -i '\#install devices/kwikwai#d' Makefile
	rm conf/agokwikwai.service
	sed -i '\#install devices/blinkm#d' Makefile
	rm conf/agoblinkm.service
	sed -i '\#install devices/i2c#d' Makefile
	rm conf/agoi2c.service
	sed -i '\#install devices/onvif#d' Makefile
	sed -i '\#install devices/mediaproxy#d' Makefile
	sed -i '\#install devices/chromoflex#d' Makefile
	sed -i '\#install devices/agoapc#d' Makefile
	sed -i '\#install -d $(DESTDIR)/etc/opt/agocontrol/apc#d' Makefile
	rm conf/agoapc.service
	sed -i '\#install devices/agojointspace#d' Makefile
	sed -i '\#install -d $(DESTDIR)/etc/opt/agocontrol/jointspace#d' Makefile
	rm conf/agojointspace.service
	sed -i '\#install gateways/agomeloware#d' Makefile
	rm conf/agomeloware.service
	sed -i '\#install devices/agodmx#d' Makefile
	sed -i '\#install devices/raspiGPIO#d' Makefile
	rm conf/raspiGPIO.service
	sed -i '\#install devices/raspi1wGPIO#d' Makefile
	rm conf/raspi1wGPIO.service
	sed -i '\#install devices/raspiMCP3xxxGPIO#d' Makefile
	rm conf/raspiMCP3xxxGPIO.service
	sed -i '\#install devices/gc100#d' Makefile
	rm conf/agogc100.service

	rm conf/agoradiothermostat.service
	rm conf/agosqueezeboxserver.service
}

src_compile() {
	MAKE_TARGETS="manager messagesend resolver agotimer"
	
	# MAKE_TARGETS="${MAKE_TARGETS} zwave"
	# MAKE_TARGETS="${MAKE_TARGETS} agochromoflex"
	# MAKE_TARGETS="${MAKE_TARGETS} agoknx"
	MAKE_TARGETS="${MAKE_TARGETS} agorpc"
	# MAKE_TARGETS="${MAKE_TARGETS} rain8net"
	# MAKE_TARGETS="${MAKE_TARGETS} kwikwai"
	# MAKE_TARGETS="${MAKE_TARGETS} irtransethernet"
	# MAKE_TARGETS="${MAKE_TARGETS} firmata"
	# MAKE_TARGETS="${MAKE_TARGETS} blinkm"
	# MAKE_TARGETS="${MAKE_TARGETS} i2c"
	# MAKE_TARGETS="${MAKE_TARGETS} mediaproxy"

	# First build common so it is available for linking
	emake common

	emake ${MAKE_TARGETS}
}
