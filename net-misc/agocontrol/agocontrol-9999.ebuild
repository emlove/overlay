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
IUSE="apc asterisk blinkm chromoflex enigma2 enocean firmata gc100 i2c
	irtrans jointspace knx kwikwai mcp3xxx mediaproxy one-wire onkyo rain8net
	raspberry-pi zwave"

DEPEND="dev-cpp/yaml-cpp
		dev-libs/jsoncpp
		dev-python/pyyaml
		dev-python/qpid-python
		dev-python/sqlite3dbm
		net-misc/qpid-cpp
		apc? ( >=dev-python/pysnmp-4.0 )
		asterisk? ( dev-python/twisted-core dev-python/starpy )
		blinkm? ( sys-apps/i2c-tools )
		enigma2? ( net-dns/avahi[python] dev-python/pygobject
			dev-python/dbus-python )
		i2c? ( sys-apps/i2c-tools )
		zwave? ( virtual/udev dev-libs/open-zwave )"
RDEPEND="${DEPEND}"

pkg_setp() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	python_convert_shebangs -r 2 .

	DEVICES="syslog"
	use apc 		&& DEVICES+=" agoapc"
	use asterisk 	&& DEVICES+=" asterisk"
	use blinkm 		&& DEVICES+=" blinkm"
	use chromoflex 	&& DEVICES+=" chromoflex"
	use enigma2		&& DEVICES+=" enigma2"
	use enocean		&& DEVICES+=" agoEnOcean"
	use firmata		&& DEVICES+=" firmata"
	use gc100		&& DEVICEs+=" gc100"
	use i2c			&& DEVICES+=" i2c"
	use irtrans		&& DEVICES+=" irtrans_ethernet"
	use jointspace	&& DEVICES+=" agojointspace"
	# TODO: package libeibclient
	use knx		&& DEVICES+=" agoknx"
	use kwikwai		&& DEVICES+=" kwikwai"
	use mediaproxy	&& DEVICES+=" mediaproxy"
	# TODO: package python-ow
	use one-wire	&& DEVICES+=" 1wire"
	use onkyo		&& DEVICES+=" onkyo"
	use rain8net	&& DEVICES+=" rain8net"
	use zwave		&& DEVICES+=" zwave"
	if use raspberry-pi ; then
		DEVICES+=" raspiGPIO"
		use mcp3xxx 	&& DEVICES+=" raspiMCP3xxxGPIO"
		use one-wire 	&& DEVICES+=" raspi1wGPIO"
	fi

	sed -i "s/^DIRS = .*/DIRS = ${DEVICES}/" devices/Makefile

	rm conf/agoowfs.service
	use enigma2 	|| rm conf/agoenigma2.service
	use asterisk 	|| rm conf/agoasterisk.service
	use onkyo 		|| rm conf/agoiscp.service
	use zwave 		|| sed -i '\#install scripts/convert-zwave-uuid#d' Makefile
	use zwave 		|| rm conf/agozwave.service
	rm conf/agoknx.service
	use firmata 	|| rm conf/agofirmata.service
	use rain8net	|| rm conf/agorain8net.service
	use irtrans		|| rm conf/agoirtransethernet.service
	use kwikwai		|| rm conf/agokwikwai.service
	use blinkm		|| rm conf/agoblinkm.service
	use i2c			|| rm conf/agoi2c.service
	use apc			|| rm conf/agoapc.service
	use jointspace	|| rm conf/agojointspace.service
	use raspberry-pi|| rm conf/raspiGPIO.service
	( use raspberry-pi && use one-wire )	|| rm conf/raspi1wGPIO.service
	( use raspberry-pi && use mcp3xxx )		|| rm conf/raspiMCP3xxxGPIO.service
	use gc100 || rm conf/agogc100.service

	# These devices aren't installed in upstream makefile. 
	# Ensure we don't install the service files.
	rm conf/agoradiothermostat.service
	rm conf/agosqueezeboxserver.service
}
