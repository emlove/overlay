# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

DESCRIPTION="An open-source interface to Z-Wave networks."
HOMEPAGE="http://open-zwave.googlecode.com"
ESVN_REPO_URI="http://open-zwave.googlecode.com/svn/trunk/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE=""
SLOT="0"

DEPEND="dev-libs/libxml2"
RDEPEND="${RDEPEND}"

src_compile() {
	emake -C cpp/build/linux || die
}

src_install() {
	dodir /etc/openzwave
	dodir /usr/include/openzwave
	dodir /usr/share/openzwave
	dodir /usr/lib
	insinto /usr/share/openzwave
	doins -r config
	exeinto /usr/lib
	dolib.so cpp/lib/linux/libopenzwave.so
	dolib.a cpp/lib/linux/libopenzwave.a
	insinto /usr/include/openzwave
	doins cpp/src/*.h cpp/src/value_classes/*.h cpp/src/command_classes/*.h cpp/src/platform/*.h cpp/src/platform/unix/*.h
#	dodoc README* AUTHORS TODO* COPYING
}
