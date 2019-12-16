# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PHP_EXT_NAME="ast"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php7-0 php7-1 php7-2 php7-3 php7-4"

inherit php-ext-source-r3

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Extension exposing PHP 7 abstract syntax tree"
HOMEPAGE="https://github.com/nikic/php-ast"
SRC_URI="https://github.com/nikic/php-ast/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"

DOCS=( README.md )
