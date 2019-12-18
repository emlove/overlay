# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

USE_PHP="php7-1 php7-2 php7-3 php7-4"

inherit php-ext-pecl-r3

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Extension exposing PHP 7 abstract syntax tree"
HOMEPAGE="https://github.com/nikic/php-ast"
LICENSE="BSD"
SLOT="0"

DOCS=( README.md )
