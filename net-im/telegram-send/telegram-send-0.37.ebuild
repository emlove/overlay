# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..13} )

PYPI_NO_NORMALIZE=1
inherit pypi distutils-r1

DESCRIPTION="Telegram-send is a command-line tool to send messages and files over Telegram to your account, to a group or to a channel. It provides a simple interface that can be easily called from other programs."
HOMEPAGE="https://github.com/rahiel/telegram-send"

SRC_URI="$(pypi_sdist_url --no-normalize)"

KEYWORDS="~amd64"
LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
	>=dev-python/python-telegram-bot-20.6[${PYTHON_USEDEP}]
"

pkg_config() {
	telegram-send --configure
}

