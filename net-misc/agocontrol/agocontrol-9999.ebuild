# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_DEPEND="2:2.7"

inherit cmake-utils git-2 python user eutils

DESCRIPTION="Ago control home automation suite"
HOMEPAGE="http://www.agocontrol.com/"

EGIT_REPO_URI="http://git.agocontrol.com/agocontrol/agocontrol.git"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="apc asterisk blinkm chromoflex dmx enigma2 enocean firmata gc100 i2c
	irtrans jointspace +jsonrpc knx kwikwai lua mcp3xxx mediaproxy meloware
	one-wire onkyo rain8net raspberry-pi webcam zwave"

DEPEND="<dev-cpp/yaml-cpp-0.5.0
		dev-libs/boost
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
		lua? ( =dev-lang/lua-5.2* )
		zwave? ( virtual/udev dev-libs/open-zwave )"
RDEPEND="${DEPEND}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup

	enewgroup agocontrol
	enewuser agocontrol -1 -1 "/var/run/agocontrol" "agocontrol,uucp,dialout"

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
}

src_configure() {
	local mycmakeargs=(
		-DBINDIR=/usr/lib/${PN}
        -DCONFDIR=/etc/${PN}
        -DDATADIR=/usr/share/${PN}
        -DLOCALSTATEDIR=/var/${PN}
        -DHTMLDIR=/usr/share/${PN}/html

		$(cmake-utils_use_build jsonrpc CORE_rpc)
		$(cmake-utils_use_build lua CORE_lua)

		$(cmake-utils_use_build one-wire DEVICE_1wire)
		-DBUILD_DEVICE_PLCBUS=OFF
		$(cmake-utils_use_build apc DEVICE_agoapc)
		$(cmake-utils_use_build dmx DEVICE_agodmx)
		$(cmake-utils_use_build jointspace DEVICE_agojointspace)
		-DBUILD_DEVICE_alert=OFF
		$(cmake-utils_use_build asterisk DEVICE_asterisk)
		$(cmake-utils_use_build blinkm DEVICE_blinkm)
		$(cmake-utils_use_build chromoflex DEVICE_chromoflex)
		$(cmake-utils_use_build enigma2 DEVICE_enigma2)
		$(cmake-utils_use_build enocean DEVICE_enocean3)
		$(cmake-utils_use_build firmata DEVICE_firmata)
		$(cmake-utils_use_build gc100 DEVICE_gc100)
		$(cmake-utils_use_build i2c DEVICE_i2c)
		-DBUILD_DEVICE_ipx800=OFF
		$(cmake-utils_use_build irtrans DEVICE_irtrans_ethernet)
		$(cmake-utils_use_build knx DEVICE_knx)
		$(cmake-utils_use_build kwikwai DEVICE_kwikwai)
		$(cmake-utils_use_build mediaproxy DEVICE_mediaproxy)
		$(cmake-utils_use_build onkyo DEVICE_onkyo)
		$(cmake-utils_use_build rain8net DEVICE_rain8net)
		$(cmake-utils_use_build raspberry-pi DEVICE_raspi1wGPIO)
		$(cmake-utils_use_build raspberry-pi DEVICE_raspiCamera)
		$(cmake-utils_use_build raspberry-pi DEVICE_raspiGPIO)
		$(cmake-utils_use_build raspberry-pi DEVICE_raspiMCP3xxxGPIO)
		-DBUILD_DEVICE_scheduler=OFF
		-DBUILD_DEVICE_squeezebox=OFF
		-DBUILD_DEVICE_syslog=ON
		-DBUILD_DEVICE_temperatur.nu=OFF
		-DBUILD_DEVICE_wake_on_lan=OFF
		$(cmake-utils_use_build webcam DEVICE_webcam)
		-DBUILD_DEVICE_x10=OFF
		-DBUILD_DEVICE_zwave=OFF
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

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

	# No longer needed?
	# insinto /usr/share/agocontrol/
	# use jsonrpc && doins -r core/rpc/html
	# use jsonrpc && fperms +x -R /usr/share/agocontrol/html/cgi-bin/

	dodir /var/agocontrol
	fowners -R agocontrol:agocontrol /var/agocontrol
}

pkg_postinst() {
	ewarn "Before you can use ${PN}, you must setup the initial configuration."
	ewarn "You can load default configurations by running 'emerge --config ${PN}'"
}

pkg_config() {
	PASSWD=letmein

	grep "00000000-0000-0000-000000000000" /etc/agocontrol/conf.d/system.conf > /dev/null && (
		UUID=$(uuidgen)
		sed -i "s/00000000-0000-0000-000000000000/${UUID}/" /etc/agocontrol/conf.d/system.conf
	)

	test -e "${ROOT}"/etc/agocontrol/db/inventory.db || (
		sqlite3 -init "${ROOT}"/usr/share/${PN}/data/inventory.sql \
			"${ROOT}"/etc/agocontrol/db/inventory.db .quit && \
		sqlite3 -init "${ROOT}"/usr/share/${PN}/data/inventory-upgrade.sql \
			"${ROOT}"/etc/agocontrol/db/inventory.db .quit && \
		chown agocontrol:agocontrol "${ROOT}"/etc/agocontrol/db/inventory.db && \
		einfo "Installed /etc/agocontrol/db/inventory.db"
	)

	test -e "${ROOT}"/var/agocontrol/datalogger.db || (
		sqlite3 -init "${ROOT}"/usr/share/${PN}/data/datalogger.sql \
			"${ROOT}"/var/agocontrol/datalogger.db .quit && \
		chown agocontrol:agocontrol "${ROOT}"/var/agocontrol/datalogger.db && \
		einfo "Installed /var/agocontrol/datalogger.db"
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
