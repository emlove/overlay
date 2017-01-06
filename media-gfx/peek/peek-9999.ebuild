# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit gnome2-utils cmake-utils vala git-r3

DESCRIPTION="An animated GIF recorder"
HOMEPAGE="https://github.com/phw/peek"
EGIT_REPO_URI="https://github.com/phw/peek"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	>=x11-libs/gtk+-3.14
	>=dev-libs/glib-2.38
	virtual/ffmpeg
	media-gfx/imagemagick"
DEPEND="${REPEND}
	dev-lang/vala
	sys-devel/gettext"

pkg_preinst() {
	gnome2_schemas_savelist
}

src_prepare() {
	eapply_user
	vala_src_prepare --ignore-use
}

src_configure() {
	local mycmakeargs=(
		-DVALA_EXECUTABLE="${VALAC}"
		-DGSETTINGS_COMPILE="false"
		)

	cmake-utils_src_configure
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
