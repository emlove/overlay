# Copyright 1999-2014 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

DESCRIPTION="Library for the Hebrew calendar and times of day"
HOMEPAGE="http://libhdate.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE="pascal perl php python ruby"

src_configure() {
	use pascal || sed -e "/SUBDIRS =/s/pascal//" -i bindings/Makefile.{am,in} ||
		die "sed failed"
	use perl || sed -e "/SUBDIRS =/s/perl//" -i bindings/Makefile.{am,in} ||
		die "sed failed"
	use php || sed -e "/SUBDIRS =/s/php//" -i bindings/Makefile.{am,in} ||
		die "sed failed"
	use python || sed -e "/SUBDIRS =/s/python//" -i bindings/Makefile.{am,in} ||
		die "sed failed"
	use ruby || sed -e "/SUBDIRS =/s/ruby//" -i bindings/Makefile.{am,in} ||
		die "sed failed"

	econf
}
