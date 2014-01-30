# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_DEPEND="2:2.7"

inherit git-2 python user eutils

DESCRIPTION="Ago control home automation suite"
HOMEPAGE="http://www.agocontrol.com/"

EGIT_REPO_URI="http://agocontrol.com/agocontrol.git"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="apc asterisk blinkm chromoflex dmx enigma2 enocean firmata gc100 i2c
	irtrans jointspace +jsonrpc knx kwikwai mcp3xxx mediaproxy meloware
	one-wire onkyo rain8net raspberry-pi webcam zwave"

DEPEND="<dev-cpp/yaml-cpp-0.5.0
		=dev-lang/lua-5.2*
		=dev-libs/boost-1.49.0*
		dev-libs/jsoncpp
		dev-libs/libhdate
		dev-libs/openssl
		dev-python/pandas
		dev-python/psutil
		dev-python/pyyaml
		dev-python/qpid-python
		dev-python/sqlite3dbm
		net-misc/curl
		net-misc/qpid-cpp[sasl]
		apc? ( >=dev-python/pysnmp-4.0 )
		asterisk? ( dev-python/twisted-core dev-python/starpy )
		blinkm? ( sys-apps/i2c-tools )
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
	use enocean && DEVICES+=" enocean3"
	use firmata && DEVICES+=" firmata"
	use gc100 && DEVICEs+=" gc100"
	use i2c && DEVICES+=" i2c"
	use irtrans && DEVICES+=" irtrans_ethernet"
	use jointspace && DEVICES+=" agojointspace"
	# TODO: package libeibclient
	use knx && DEVICES+=" knx"
	use kwikwai && DEVICES+=" kwikwai"
	use mediaproxy && DEVICES+=" mediaproxy"
	# TODO: package python-ow
	use one-wire && DEVICES+=" 1wire"
	use onkyo && DEVICES+=" onkyo"
	use rain8net && DEVICES+=" rain8net"
	use webcam && DEVICES+=" webcam"
	use zwave && DEVICES+=" zwave"
	if use raspberry-pi ; then
		DEVICES+=" raspiGPIO"
		use mcp3xxx && DEVICES+=" raspiMCP3xxxGPIO"
		use one-wire && DEVICES+=" raspi1wGPIO"
	fi

	sed -i "s/^DIRS = .*/DIRS = ${DEVICES}/" devices/Makefile
	use jsonrpc || sed -i '/DIRS = /{s/rpc//}' core/Makefile

	use apc || rm conf/systemd/agoapc.service
	use asterisk || rm conf/systemd/agoasterisk.service
	use blinkm || rm conf/systemd/agoblinkm.service
	use dmx || rm conf/systemd/agodmx.service
	use enigma2 || rm conf/systemd/agoenigma2.service
	use firmata || rm conf/systemd/agofirmata.service
	use gc100 || rm conf/systemd/agogc100.service
	use i2c || rm conf/systemd/agoi2c.service
	use irtrans || rm conf/systemd/agoirtransethernet.service
	use jointspace || rm conf/systemd/agojointspace.service
	use jsonrpc || rm conf/systemd/agorpc.service
	use knx || rm conf/systemd/agoknx.service
	use kwikwai || rm conf/systemd/agokwikwai.service
	use meloware || sed -i '\#install gateways/agomeloware.py#d' Makefile
	use meloware || rm conf/systemd/agomeloware.service
	use one-wire || rm conf/systemd/agoowfs.service
	use onkyo || rm conf/systemd/agoiscp.service
	use rain8net || rm conf/systemd/agorain8net.service
	use webcam || rm conf/systemd/agowebcam.service
	use zwave || sed -i '\#install scripts/convert-zwave-uuid#d' Makefile
	use zwave || rm conf/systemd/agozwave.service
	use raspberry-pi || rm conf/systemd/raspiGPIO.service
	( use raspberry-pi && use one-wire ) || rm conf/systemd/raspi1wGPIO.service
	( use raspberry-pi && use mcp3xxx ) || rm conf/systemd/raspiMCP3xxxGPIO.service

	# These devices aren't installed in upstream makefile. 
	# Ensure we don't install the service files.
	rm conf/systemd/agoradiothermostat.service
	rm conf/systemd/agosqueezeboxserver.service

	sed -i '\#install data/inventory.sql#d' Makefile
	sed -i '\#install data/datalogger.sql#d' Makefile
}

src_install() {
	emake DESTDIR="${D}" install

	use apc && newinitd "${FILESDIR}"/agoapc.init agoapc
	use asterisk && newinitd "${FILESDIR}"/agoasterisk.init agoasterisk
	use blinkm && newinitd "${FILESDIR}"/agoblinkm.init agoblinkm
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
	use webcam && newinitd "${FILESDIR}"/agowebcam.init agowebcam
	use zwave && newinitd "${FILESDIR}"/agozwave.init agozwave

	insinto /opt/agocontrol/
	use jsonrpc && doins -r core/rpc/html
	use jsonrpc && fperms +x -R /opt/agocontrol/html/cgi-bin/

	fowners -R agocontrol:agocontrol /etc/opt/agocontrol
	fowners -R agocontrol:agocontrol /var/opt/agocontrol

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

	grep "00000000-0000-0000-000000000000" /etc/opt/agocontrol/conf.d/system.conf > /dev/null && (
		UUID=$(uuidgen)
		sed -i "s/00000000-0000-0000-000000000000/${UUID}/" /etc/opt/agocontrol/conf.d/system.conf
	)

	test -e "${ROOT}"/etc/opt/agocontrol/db/inventory.db || (
		sqlite3 -init "${ROOT}"/usr/share/${PN}/data/inventory.sql \
			"${ROOT}"/etc/opt/agocontrol/db/inventory.db .quit && \
		sqlite3 -init "${ROOT}"/usr/share/${PN}/data/inventory-upgrade.sql \
			"${ROOT}"/etc/opt/agocontrol/db/inventory.db .quit && \
		chown agocontrol:agocontrol "${ROOT}"/etc/opt/agocontrol/db/inventory.db && \
		einfo "Installed /etc/opt/agocontrol/db/inventory.db"
	)

	test -e "${ROOT}"/var/opt/agocontrol/datalogger.db || (
		sqlite3 -init "${ROOT}"/usr/share/${PN}/data/datalogger.sql \
			"${ROOT}"/var/opt/agocontrol/datalogger.db .quit && \
		chown agocontrol:agocontrol "${ROOT}"/var/opt/agocontrol/datalogger.db && \
		einfo "Installed /var/opt/agocontroll/datalogger.db"
	)

	sasldblistusers2 -f "${ROOT}"/var/lib/qpidd/qpidd.sasldb | \
	grep -q agocontrol || (
		echo $PASSWD | \
			saslpasswd2 -c -p -f "${ROOT}"/var/lib/qpidd/qpidd.sasldb \
			-u QPID agocontrol && \
		einfo "Added agocontrol to /var/lib/qpidd/qpidd.ssasldb"
	)

	test -e "${ROOT}"/etc/qpid/qpidd.acl && (
		grep -q agocontrol "${ROOT}"/etc/qpid/qpiddd.acl || sed -i \
			's/admin@QPID/admin@QPID agocontrol@QPID/g' \
			"${ROOT}"/etc/qpid/qpiddd.acl && \
		einfo "Added agocontrol to /etc/qpid/qpidd.acl"
	)
}
