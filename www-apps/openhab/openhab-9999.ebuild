# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit mercurial java-pkg-2 user

DESCRIPTION="A universal integration platform for home automation"
HOMEPAGE="http://code.google.com/p/openhab/"

EHG_REPO_URI="https://code.google.com/p/openhab/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="addons +designer +runtime"

DEPEND=">=virtual/jdk-1.6
		dev-java/maven-bin:3.0
		app-arch/unzip"
RDEPEND=">=virtual/jre-1.6"

pkg_setup() {
	java-pkg-2_pkg_setup

	addpredict "/dev/random"

	enewgroup openhab
	enewuser openhab -1 -1 -1 "openhab"
}

src_compile() {
	MVN_LOCAL_REPO="${T}/maven-local-repo"
	mkdir -p "${MVN_LOCAL_REPO}" || die "Unable to create maven repo directory"

	mvn-3.0 -Dmaven.repo.local="${MVN_LOCAL_REPO}" clean install || \
	        die "Maven failed to complete build process. See log for details"
}

src_install() {
	if use runtime ; then
		unzip distribution/target/*-runtime.zip -d distribution/target/runtime
		if use addons ; then
			unzip distribution/target/*-addons.zip -d distribution/target/runtime/addons
		fi

		insinto /opt/openhab-runtime
		doins -r distribution/target/runtime/*
		fperms +x /opt/openhab-runtime/start.sh
		fowners -R openhab:openhab /opt/openhab-runtime

		newinitd "${FILESDIR}"/openhab-runtime.init openhab-runtime
		newconfd "${FILESDIR}"/openhab-runtime.conf openhab-runtime
	fi

	if use designer ; then
		if use amd64 ; then
			unzip distribution/target/*-designer-linux64bit.zip -d \
			distribution/target/designer
		else
			unzip distribution/target/*-designer-linux.zip -d \
			distribution/target/designer
		fi
		insinto /opt/openhab-designer
		doins -r distribution/target/designer/*
		fperms +x /opt/openhab-designer/openHAB-Designer
	fi
}
