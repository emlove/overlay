# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{3_3,3_4,3_5} )

inherit eutils git-r3 python-r1 systemd user fcaps

DESCRIPTION="Flic SDK for Linux"
HOMEPAGE="https://github.com/50ButtonsEach/fliclib-linux-hci"
EGIT_REPO_URI="https://github.com/50ButtonsEach/fliclib-linux-hci.git"

LICENSE="UNKNOWN"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	sys-libs/libcap"

RDEPEND=""

QA_PREBUILT="
	usr/bin/flicd"

FILECAPS=(
	cap_net_admin=ep usr/bin/flicd
)

pkg_setup() {
	enewgroup flicd
	enewuser flicd -1 -1 /var/lib/flicd flicd	
}

src_compile() {
	cd simpleclient
	emake
}

src_install() {
	# Install daemon
	if use amd64 ; then
		dobin bin/x86_64/flicd
	fi

	keepdir "/var/lib/flicd"
	fowners flicd:flicd "/var/lib/flicd"

	systemd_dounit "${FILESDIR}/flicd.service"

	# Install clients
	newbin simpleclient/simpleclient flic-simpleclient

	python_foreach_impl python_domodule "clientlib/python/fliclib.py"
}
