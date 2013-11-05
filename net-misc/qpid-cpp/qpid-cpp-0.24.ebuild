# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2:2.7"

inherit cmake-utils python

MY_D="qpidd"
MY_SPN="qpid"
MY_SP="${MY_SPN}-${PV}"

DESCRIPTION="A cross-platform Enterprise Messaging system which implements the Advanced Message Queuing Protocol"
HOMEPAGE="http://qpid.apache.org"
SRC_URI="mirror://apache/qpid/${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc sasl static-libs xml infiniband ssl test"

COMMON_DEP=">=dev-libs/boost-1.41.0-r3
	sasl? ( dev-libs/cyrus-sasl )
	xml? ( dev-libs/xerces-c
			dev-libs/xqilla[faxpp] )
	ssl? ( dev-libs/nss
			dev-libs/nspr )
	infiniband? ( sys-infiniband/libibverbs
				sys-infiniband/librdmacm )
	sys-apps/util-linux"

DEPEND="sys-apps/help2man
	test? ( dev-util/valgrind )
	${COMMON_DEP}"

RDEPEND="${COMMON_DEP}"
BDEPEND="dev-lang/ruby
	${DEPEND}"

S="${WORKDIR}/qpidc-${PV}"
DOCS=(DESIGN INSTALL README.txt RELEASE_NOTES SSL)

pkg_setup() {
	enewgroup ${MY_D}
	enewuser ${MY_D} -1 -1 -1 ${MY_D}

	python_pkg_setup
	python_set_active_version 2
}

src_prepare() {
	epatch "${FILESDIR}"/qpid-cpp-0.24-fix-perl-install.patch

	python_convert_shebangs -r 2 .
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use doc GEN_DOXYGEN)
		$(cmake-utils_use_build sasl)
		$(cmake-utils_use_build xml)
		$(cmake-utils_use_build infiniband RDMA)
		$(cmake-utils_use_build ssl)
		$(cmake-utils_use_build test TESTING)
		-DPYTHON_EXECUTABLE=/usr/bin/python2
		-DPythonLibs_FIND_VERSION=2.7
		-DPYTHON_LIBRARIES=/usr/lib/libpython2.7.so
		-DPYTHON_INCLUDE_PATH=/usr/include/python2.7 )
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	rm "${D}"/etc/init.d/qpidd-primary

	newinitd "${FILESDIR}"/${MY_D}.init ${MY_D}
	newconfd "${FILESDIR}"/${MY_D}.conf ${MY_D}

	for dir in lib run ;do
		diropts -g ${MY_D} -o ${MY_D} -m 0750
		keepdir /var/${dir}/${MY_D}
	done
}
