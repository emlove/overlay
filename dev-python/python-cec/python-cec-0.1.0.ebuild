# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_DEPEND="2"

inherit distutils git-2

DESCRIPTION="libcec bindings for Python"
EGIT_REPO_URI="https://github.com/trainman419/${PN}.git"
EGIT_COMMIT="${PV}"
HOMEPAGE="https://github.com/trainman419/python-cec"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="dev-libs/libcec"
RDEPEND="${DEPEND}"

DOCS="README.md"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}
