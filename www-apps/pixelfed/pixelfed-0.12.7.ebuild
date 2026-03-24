# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit webapp

DESCRIPTION="Photo Sharing. For Everyone."
HOMEPAGE="https://pixelfed.org/"
SRC_URI="https://github.com/pixelfed/pixelfed/archive/refs/tags/v${PV}.tar.gz"

LICENSE="AGPL-3"
KEYWORDS="~amd64"

IUSE="mysql postgres"
REQUIRED_USE="|| ( mysql postgres )"

RDEPEND=">=dev-lang/php-8.3[bcmath,ctype,curl,exif,gd,iconv,intl,ssl,tokenizer,xml,zip,pdo,mysql?,postgres?]
	media-gfx/jpegoptim
	media-gfx/optipng
	media-gfx/pngquant
	media-video/ffmpeg
	dev-php/pecl-redis
	virtual/httpd-php"

BDEPEND="${BDEPEND}
	dev-php/composer"

RESTRICT=network-sandbox # I just want the software to work, OK

src_unpack() {
	default
	(cd "${S}" && /usr/bin/composer install --no-ansi --no-interaction --optimize-autoloader) || die
}

pkg_setup() {
	webapp_pkg_setup
}

src_install() {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_serverowned -R "${MY_HTDOCSDIR}"

	webapp_src_install
}
