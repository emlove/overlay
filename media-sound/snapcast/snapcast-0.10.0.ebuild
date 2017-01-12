# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3

DESCRIPTION="Synchronous audio player"
HOMEPAGE="https://github.com/badaix/snapcast"
EGIT_REPO_URI="https://github.com/badaix/snapcast.git"
EGIT_COMMIT="v${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+client +server"

DEPEND="
	>=sys-devel/gcc-4.8
	media-libs/alsa-lib
	media-libs/tremor
	media-libs/libvorbis
	media-libs/flac
	media-sound/alsa-utils
	net-dns/avahi"

RDEPEND="${DEPEND}"

src_compile() {
	# Override the strip binary to : to prevent stripping debug symbols
	# Upstream makefile doesn't supply a better alternative.
	STRIP=":"

	use server && emake STRIP="${STRIP}" server
	use client && emake STRIP="${STRIP}" client
}

src_install() {
	use server && emake DESTDIR="${D}" installserver
	use client && emake DESTDIR="${D}" installclient
}
