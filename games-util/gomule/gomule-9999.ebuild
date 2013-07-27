# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit games java-pkg-2 java-ant-2 git-2

DESCRIPTION="A muling application for Diablo 2."
HOMEPAGE="http://gomule.sourceforge.net/"
EGIT_REPO_URI="git://gomule.git.sourceforge.net/gitroot/gomule/gomule"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

EANT_BUILD_TARGET="Jar-Build"
JAVA_ANT_REWRITE_CLASSPATH="true"

DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5"

pkg_setup() {
	java-pkg-2_pkg_setup
	games_pkg_setup
}

src_prepare() {
	S="${S}/${PN}"
}
