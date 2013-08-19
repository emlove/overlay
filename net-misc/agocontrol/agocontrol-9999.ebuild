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
IUSE="systemd"

DEPEND="dev-libs/jsoncpp
		dev-python/pyyaml
		dev-python/qpid-python
		dev-python/sqlite3dbm
		net-misc/qpid-cpp
		systemd? ( sys-apps/systemd )"
RDEPEND="${DEPEND}"

pkg_setp() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	python_convert_shebangs -r 2 .
}
