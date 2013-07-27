# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit mercurial java-pkg-2 java-ant-2

DESCRIPTION="A universal integration platform for home automation"
HOMEPAGE="http://code.google.com/p/openhab/"

EHG_REPO_URI="https://code.google.com/p/openhab/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=virtual/jdk-1.6
		dev-java/maven-bin:3.0"
RDEPEND=">=virtual/jre-1.6"

