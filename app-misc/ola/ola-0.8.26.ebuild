# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_DEPEND="2"

inherit flag-o-matic autotools eutils python

DESCRIPTION="Open Lighting Architecture"
HOMEPAGE="http://code.google.com/p/linux-lighting/"
SRC_URI="http://open-lighting.googlecode.com/files/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="examples httpd python"

DEPEND="	dev-libs/protobuf[python]
		dev-util/cppunit
		httpd? ( net-libs/libmicrohttpd[messages] )"
RDEPEND="${DEPEND}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
        eautoreconf
}

src_configure() {
	econf	--prefix=/usr \
		--disable-fatal-warnings \
		$(use_enable examples) \
		$(use_enable httpd http) \
		$(use_enable python python-libs)
}
