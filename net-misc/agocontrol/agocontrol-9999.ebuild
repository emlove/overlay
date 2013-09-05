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
IUSE="apc asterisk blinkm +cherrypy chromoflex dmx enigma2 enocean firmata
	gc100 i2c irtrans jointspace jsonrpc knx kwikwai mcp3xxx mediaproxy
	meloware one-wire onkyo rain8net raspberry-pi zwave"

DEPEND="<dev-cpp/yaml-cpp-0.5.0
		dev-libs/boost
		dev-libs/jsoncpp
		dev-libs/openssl
		dev-python/pandas
		dev-python/pyyaml
		dev-python/qpid-python
		dev-python/sqlite3dbm
		net-misc/qpid-cpp[sasl]
		apc? ( >=dev-python/pysnmp-4.0 )
		asterisk? ( dev-python/twisted-core dev-python/starpy )
		blinkm? ( sys-apps/i2c-tools )
		cherrypy? ( =dev-python/cherrypy-3* dev-python/mako
			dev-python/simplejson net-dns/avahi[python] dev-python/dbus-python
			dev-python/pygobject )
		enigma2? ( net-dns/avahi[python] dev-python/pygobject
			dev-python/dbus-python )
		i2c? ( sys-apps/i2c-tools )
		zwave? ( virtual/udev dev-libs/open-zwave )"
RDEPEND="${DEPEND}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup

	enewgroup agocontrol
	enewuser agocontrol -1 -1 "/var/run/agocontrol" "agocontrol,uucp"

	if use blinkm || use i2c ; then
		ewarn "The blinkm and i2c devices require the i2c-dev.h header"
		ewarn "installed by the i2c-tools package. Gentoo does not"
		ewarn "install this header because it conflicts with the"
		ewarn "version installed by sys-kernel/linux-headers. Building"
		ewarn "these devices on gentoo will require the i2c-tools-4.0"
		ewarn "package as described by upstream on the following page"
		ewarn "http://www.lm-sensors.org/wiki/I2CTools_4_Plan"
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${P}-use-openzwave-share.patch"

	python_convert_shebangs -r 2 .

	DEVICES="syslog"
	use apc && DEVICES+=" agoapc"
	use asterisk && DEVICES+=" asterisk"
	use blinkm && DEVICES+=" blinkm"
	use chromoflex && DEVICES+=" chromoflex"
	use dmx && DEVICES+=" agodmx"
	use enigma2 && DEVICES+=" enigma2"
	use enocean && DEVICES+=" agoEnOcean"
	use firmata && DEVICES+=" firmata"
	use gc100 && DEVICEs+=" gc100"
	use i2c && DEVICES+=" i2c"
	use irtrans && DEVICES+=" irtrans_ethernet"
	use jointspace && DEVICES+=" agojointspace"
	# TODO: package libeibclient
	use knx && DEVICES+=" agoknx"
	use kwikwai && DEVICES+=" kwikwai"
	use mediaproxy && DEVICES+=" mediaproxy"
	# TODO: package python-ow
	use one-wire && DEVICES+=" 1wire"
	use onkyo && DEVICES+=" onkyo"
	use rain8net && DEVICES+=" rain8net"
	use zwave && DEVICES+=" zwave"
	if use raspberry-pi ; then
		DEVICES+=" raspiGPIO"
		use mcp3xxx && DEVICES+=" raspiMCP3xxxGPIO"
		use one-wire && DEVICES+=" raspi1wGPIO"
	fi

	sed -i "s/^DIRS = .*/DIRS = ${DEVICES}/" devices/Makefile
	use jsonrpc || sed -i '/DIRS = /{s/rpc//}' core/Makefile

	use apc || rm conf/agoapc.service
	use asterisk || rm conf/agoasterisk.service
	use blinkm || rm conf/agoblinkm.service
	use cherrypy || rm conf/agoadmin.service
	use dmx || rm conf/agodmx.service
	use enigma2 || rm conf/agoenigma2.service
	use firmata || rm conf/agofirmata.service
	use gc100 || rm conf/agogc100.service
	use i2c || rm conf/agoi2c.service
	use irtrans || rm conf/agoirtransethernet.service
	use jointspace || rm conf/agojointspace.service
	use jsonrpc || rm conf/agorpc.service
	use knx || rm conf/agoknx.service
	use kwikwai || rm conf/agokwikwai.service
	use meloware || sed -i '\#install gateways/agomeloware.py#d' Makefile
	use meloware || rm conf/agomeloware.service
	use one-wire || rm conf/agoowfs.service
	use onkyo || rm conf/agoiscp.service
	use rain8net || rm conf/agorain8net.service
	use zwave || sed -i '\#install scripts/convert-zwave-uuid#d' Makefile
	use zwave || rm conf/agozwave.service
	use raspberry-pi || rm conf/raspiGPIO.service
	( use raspberry-pi && use one-wire ) || rm conf/raspi1wGPIO.service
	( use raspberry-pi && use mcp3xxx ) || rm conf/raspiMCP3xxxGPIO.service

	# These devices aren't installed in upstream makefile. 
	# Ensure we don't install the service files.
	rm conf/agoradiothermostat.service
	rm conf/agosqueezeboxserver.service

	sed -i '\#install conf/config.ini.tpl#d' Makefile
	sed -i '\#install data/inventory.sql#d' Makefile
	sed -i '\#install data/datalogger.sql#d' Makefile
}

src_install() {
	emake DESTDIR="${D}" install

	use apc && newinitd "${FILESDIR}"/agoapc.init agoapc
	use asterisk && newinitd "${FILESDIR}"/agoasterisk.init agoasterisk
	use blinkm && newinitd "${FILESDIR}"/agoblinkm.init agoblinkm
	use cherrypy && newinitd "${FILESDIR}"/agoadmin.init agoadmin
	use dmx && newinitd "${FILESDIR}"/agodmx.init agodmx
	newinitd "${FILESDIR}"/agodatalogger.init agodatalogger
	use enigma2 && newinitd "${FILESDIR}"/agoenigma2.init agoenigma2
	newinitd "${FILESDIR}"/agoevent.init agoevent
	use firmata && newinitd "${FILESDIR}"/agofirmata.init agofirmata
	use gc100 && newinitd "${FILESDIR}"/agogc100.init agogc100
	use i2c && newinitd "${FILESDIR}"/agoi2c.init agoi2c
	use irtrans && \
		newinitd "${FILESDIR}"/agoirtransethernet.init agoirtransethernet
	use onkyo && newinitd "${FILESDIR}"/agoiscp.init agoiscp
	use jointspace && newinitd "${FILESDIR}"/agojointspace.init agojointspace
	use jsonrpc && newinitd "${FILESDIR}"/agorpc.init agorpc
	use knx && newinitd "${FILESDIR}"/agoknx.init agoknx
	use kwikwai && newinitd "${FILESDIR}"/agokwikwai.init agokwikwai
	use meloware && newinitd "${FILESDIR}"/agomeloware.init agomeloware
	use one-wire && newinitd "${FILESDIR}"/agoowfs.init agoowfs
	# newinitd "${FILESDIR}"/agoradiothermostat.init agoradiothermostat
	use rain8net && newinitd "${FILESDIR}"/agorain8net.init agorain8net
	use raspberry-pi && use one-wire && \
		newinitd "${FILESDIR}"/agoraspi1wGPIO.init agoraspi1wGPIO
	use raspberry-pi && newinitd "${FILESDIR}"/agoraspiGPIO.init agoraspiGPIO
	use raspberry-pi && use mcp3xxx && \
		newinitd "${FILESDIR}"/agoraspiMCP3xxxGPIO.init agoraspiMCP3xxxGPIO
	newinitd "${FILESDIR}"/agoresolver.init agoresolver
	newinitd "${FILESDIR}"/agoscenario.init agoscenario
	newinitd "${FILESDIR}"/agosimulator.init agosimulator
	# use  newinitd "${FILESDIR}"/agosqueezeboxserver.init agosqueezeboxserver
	newinitd "${FILESDIR}"/agotimer.init agotimer
	use zwave && newinitd "${FILESDIR}"/agozwave.init agozwave

	insinto /opt/agocontrol/
	use cherrypy && doins -r admin
	use cherrypy && fperms +x /opt/agocontrol/admin/agoadmin.py
	use cherrypy && dosym ../bin/myavahi.py /opt/agocontrol/admin/myavahi.py
	use jsonrpc && doins -r core/rpc/html

	fowners -R agocontrol:agocontrol /etc/opt/agocontrol
	fowners -R agocontrol:agocontrol /var/opt/agocontrol
	fperms -R -x /etc/opt/agocontrol

	insinto /usr/share/${PN}/conf
	doins conf/config.ini.tpl
	insinto /usr/share/${PN}/data
	doins data/inventory.sql
	doins data/inventory-upgrade.sql
	doins data/datalogger.sql
}

pkg_postinst() {
	ewarn "Before you can use ${PN}, you must setup the initial configuration."
	ewarn "You can load default configurations by running 'emerge --config ${PN}'"
}

pkg_config() {
	PASSWD=letmein

	test -e "${ROOT}"/etc/opt/agocontrol/config.ini || (
		UUID=$(uuidgen)
		sed "s/<uuid>/${UUID}/" "${ROOT}"/usr/share/${PN}/conf/config.ini.tpl \
			> "${ROOT}"/etc/opt/agocontrol/config.ini && \
		chown agocontrol:agocontrol "${ROOT}"/etc/opt/agocontrol/config.ini && \
		einfo "Installed /etc/opt/agocontrol/config.ini"
	)

	test -e "${ROOT}"/etc/opt/agocontrol/inventory.db || (
		sqlite3 -init "${ROOT}"/usr/share/${PN}/data/inventory.sql \
			"${ROOT}"/etc/opt/agocontrol/inventory.db .quit && \
		sqlite3 -init "${ROOT}"/usr/share/${PN}/data/inventory-upgrade.sql \
			"${ROOT}"/etc/opt/agocontrol/inventory.db .quit && \
		chown agocontrol:agocontrol "${ROOT}"/etc/opt/agocontrol/inventory.db && \
		einfo "Installed /etc/opt/agocontrol/inventory.db"
	)

	test -e "${ROOT}"/var/opt/agocontrol/datalogger.db || (
		sqlite3 -init "${ROOT}"/usr/share/${PN}/data/datalogger.sql \
			"${ROOT}"/var/opt/agocontrol/datalogger.db .quit && \
		chown agocontrol:agocontrol "${ROOT}"/var/opt/agocontrol/datalogger.db && \
		einfo "Installed /var/opt/agocontroll/datalogger.db"
	)

	sasldblistusers2 -f "${ROOT}"/etc/qpid/qpidd.sasldb | \
	grep -q agocontrol || (
		echo $PASSWD | \
			saslpasswd2 -c -p -f "${ROOT}"/etc/qpid/qpidd.sasldb \
			-u QPID agocontrol && \
		einfo "Added agocontrol to /etc/qpid/qpidd.ssasldb"
	)

	test -e "${ROOT}"/etc/qpid/qpid.acl && (
		grep -q agocontrol "${ROOT}"/etc/qpid/qpidd.acl || sed -i \
			's/admin@QPID/admin@QPID agocontrol@QPID/g' \
			"${ROOT}"/etc/qpid/qpidd.acl && \
		einfo "Added agocontrol to /etc/qpid/qpidd.acl"
	)
}
