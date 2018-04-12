# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit unpacker versionator

DESCRIPTION="Integrate ProtonMail with IMAP and SMTP"
HOMEPAGE="https://protonmail.com/bridge"

MY_PN="${PN%-bin}"
MY_PV="$(replace_version_separator 3 '-')"
MY_PV="${MY_PV//p}"
MY_P="${MY_PN}_${MY_PV}"

SRC_URI="https://protonmail.com/download/${MY_P}_amd64.deb"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	app-crypt/libsecret
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	gnome-base/gnome-keyring
	media-fonts/dejavu
"

S=${WORKDIR}

QA_PREBUILT="*"

src_install() {
	#install the prebundled libraries
	insinto /usr/lib/protonmail
	doins -r usr/lib/protonmail/bridge
	fperms +x \
		/usr/lib/protonmail/bridge/Desktop-Bridge \
		/usr/lib/protonmail/bridge/Desktop-Bridge.sh

	#install the desktop application
	insinto /usr/share/applications
	doins usr/share/applications/Desktop-Bridge.desktop
	insinto /usr/share/icons
	doins -r usr/share/icons/protonmail

	#link the wrapper script
	dosym /usr/lib/protonmail/bridge/Desktop-Bridge.sh /usr/bin/Desktop-Bridge
}
