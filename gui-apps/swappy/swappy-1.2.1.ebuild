# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson xdg-utils optfeature

DESCRIPTION="A Wayland native snapshot and editor tool, inspired by Snappy on macOS"
HOMEPAGE="https://github.com/jtheoof/swappy"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jtheoof/swappy"
else
	SRC_URI="https://github.com/jtheoof/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"
IUSE="+libnotify man"

DEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:3
	x11-libs/cairo
	x11-libs/pango
	libnotify? ( x11-libs/libnotify )
"
RDEPEND="${DEPEND}
	media-fonts/fontawesome[otf]
"
BDEPEND="
	virtual/pkgconfig
	man? ( app-text/scdoc )
"

src_configure() {
	local emesonargs=(
		$(meson_feature man man-pages)
		$(meson_feature libnotify)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update

	optfeature "Persist clipboard after closing" gui-apps/wl-clipboard
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
