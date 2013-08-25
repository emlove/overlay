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
IUSE="apc asterisk blinkm chromoflex dmx enigma2 firmata gc100 i2c irtrans
	jointspace knx kwikwai mcp3xxx mediaproxy meloware one-wire onkyo onvif
	rain8net raspberry-pi zwave"

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

	if ! use one-wire ; then
		sed -i '\#install devices/agoowfs#d' Makefile
		sed -i '\#install -d $(DESTDIR)/etc/opt/agocontrol/owfs#d' Makefile
		rm conf/agoowfs.service
	fi
	if ! use enigma2 ; then
		sed -i '\#install devices/enigma2#d' Makefile
		rm conf/agoenigma2.service
	fi
	if ! use asterisk ; then
		sed -i '\#install devices/asterisk#d' Makefile
		rm conf/agoasterisk.service
	fi
	if ! use onkyo ; then
		sed -i '\#install devices/onkyo#d' Makefile
		rm conf/agoiscp.service
	fi
	if ! use zwave ; then
		sed -i '\#install devices/zwave#d' Makefile
		sed -i '\#install scripts/convert-zwave-uuid#d' Makefile
		sed -i '\#install -d $(DESTDIR)/etc/opt/agocontrol/uuidmap#d' Makefile
		sed -i '\#install -d $(DESTDIR)/etc/opt/agocontrol/ozw#d' Makefile
		rm conf/agozwave.service
	fi
	if ! use knx ; then
		sed -i '\#install devices/agoknx#d' Makefile
		rm conf/agoknx.service
	fi
	if ! use firmata ; then
		sed -i '\#install devices/firmata#d' Makefile
		rm conf/agofirmata.service
	fi
	if ! use rain8net ; then
		sed -i '\#install devices/rain8net#d' Makefile
		rm conf/agorain8net.service
	fi
	if ! use irtrans ; then
		sed -i '\#install devices/irtrans_ethernet#d' Makefile
		rm conf/agoirtransethernet.service
	fi
	if ! use kwikwai ; then
		sed -i '\#install devices/kwikwai#d' Makefile
		rm conf/agokwikwai.service
	fi
	if ! use blinkm ; then
		sed -i '\#install devices/blinkm#d' Makefile
		rm conf/agoblinkm.service
	fi
	if ! use i2c ; then
		sed -i '\#install devices/i2c#d' Makefile
		rm conf/agoi2c.service
	fi
	if ! use onvif ; then
		sed -i '\#install devices/onvif#d' Makefile
	fi
	if ! use mediaproxy ; then
		sed -i '\#install devices/mediaproxy#d' Makefile
	fi
	if ! use chromoflex ; then
		sed -i '\#install devices/chromoflex#d' Makefile
	fi
	if ! use apc ; then
		sed -i '\#install devices/agoapc#d' Makefile
		sed -i '\#install -d $(DESTDIR)/etc/opt/agocontrol/apc#d' Makefile
		rm conf/agoapc.service
	fi
	if ! use jointspace ; then
		sed -i '\#install devices/agojointspace#d' Makefile
		sed -i '\#install -d $(DESTDIR)/etc/opt/agocontrol/jointspace#d' Makefile
		rm conf/agojointspace.service
	fi
	if ! use meloware ; then
		sed -i '\#install gateways/agomeloware#d' Makefile
		rm conf/agomeloware.service
	fi
	if ! use dmx ; then
		sed -i '\#install devices/agodmx#d' Makefile
	fi
	if ! use raspberry-pi ; then
		sed -i '\#install devices/raspiGPIO#d' Makefile
		rm conf/raspiGPIO.service
	fi
	if ! use raspberry-pi || ! use one-wire ; then
		sed -i '\#install devices/raspi1wGPIO#d' Makefile
		rm conf/raspi1wGPIO.service
	fi
	if ! use raspberry-pi || ! use mcp3xxx ; then
		sed -i '\#install devices/raspiMCP3xxxGPIO#d' Makefile
		rm conf/raspiMCP3xxxGPIO.service
	fi
	if ! use gc100 ; then
		sed -i '\#install devices/gc100#d' Makefile
		rm conf/agogc100.service
	fi

	# These devices aren't installed in upstream makefile. 
	# Ensure we don't install the service files.
	rm conf/agoradiothermostat.service
	rm conf/agosqueezeboxserver.service
}

src_compile() {
	MAKE_TARGETS="manager messagesend resolver agotimer agorpc"
	
	use zwave && MAKE_TARGETS="${MAKE_TARGETS} zwave"
	use chromoflex && MAKE_TARGETS="${MAKE_TARGETS} agochromoflex"
	use knx && MAKE_TARGETS="${MAKE_TARGETS} agoknx"
	use rain8net && MAKE_TARGETS="${MAKE_TARGETS} rain8net"
	use kwikwai && MAKE_TARGETS="${MAKE_TARGETS} kwikwai"
	use irtrans && MAKE_TARGETS="${MAKE_TARGETS} irtransethernet"
	use firmata && MAKE_TARGETS="${MAKE_TARGETS} firmata"
	use blinkm && MAKE_TARGETS="${MAKE_TARGETS} blinkm"
	use i2c && MAKE_TARGETS="${MAKE_TARGETS} i2c"
	use mediaproxy && MAKE_TARGETS="${MAKE_TARGETS} mediaproxy"

	# First build common so it is available for linking
	emake common

	emake ${MAKE_TARGETS}
}
