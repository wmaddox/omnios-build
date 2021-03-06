#!/usr/bin/bash
#
# {{{ CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License, Version 1.0 only
# (the "License").  You may not use this file except in compliance
# with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END }}}

#
# Copyright (c) 2014 by Delphix. All rights reserved.
# Copyright 2019 OmniOS Community Edition (OmniOSce) Association.
#

. ../../lib/functions.sh

PKG=system/virtualization/open-vm-tools
PROG=open-vm-tools
VER=10.3.10
# The open-vm-tools have been inconsistent in the past in regard to whether
# the filenames and extracted directories contain the build number. If they
# do, set the build number.
BUILD=12406962
SUMMARY="Open Virtual Machine Tools"
DESC="The Open Virtual Machine Tools project aims to provide a suite of open "
DESC+="source virtualization utilities and drivers to improve the functionality "
DESC+="and user experience of virtualization. The project currently runs in "
DESC+="guest operating systems under the VMware hypervisor."

DLVER=$VER
if [ -n "$BUILD" ]; then
    set_builddir "$PROG-$VER-$BUILD"
    DLVER+=-$BUILD
fi

export PATH=/usr/gnu/bin:$PATH

# There's some hand assembly in here that only works in 32-bit
set_arch 32

BUILD_DEPENDS_IPS='developer/pkg-config'

# _FILE_OFFSET_BITS=64 - Large file interface is required
# _XPG4_2 - Need cmsg from UNIX95
# __EXTENSIONS__ - Need gethostbyname_r in _XPG4_2

CFLAGS+="\
    -std=gnu89 \
    -Wno-logical-not-parentheses \
    -Wno-bool-compare \
    -Wno-deprecated-declarations \
    -Wno-unused-local-typedefs \
    -D_FILE_OFFSET_BITS=64 \
    -D_XPG4_2 \
    -D__EXTENSIONS__ \
"
CONFIGURE_OPTS="
    --without-kernel-modules
    --disable-static
    --disable-multimon
    --without-x
    --without-dnet
    --without-icu
    --without-gtk2
    --without-gtkmm
    --enable-deploypkg=no
    --disable-grabbitmqproxy
    --without-xerces
    --disable-docs
    --without-gnu-ld
"

# Parts of the vmbackup code get generated by 'rpcgen' which adds unused
# variables. Disable -Werror for this directory.
make_prog32() {
    logcmd sed -i 's/-Werror//g' services/plugins/vmbackup/Makefile
    make_prog
}

install_conf() {
    pushd $DESTDIR > /dev/null
    logcmd mkdir -p etc/vmware-tools/ || logerr "mkdir failed"
    logcmd cp $SRCDIR/files/tools.conf etc/vmware-tools/ || logerr "cp fail"
    popd > /dev/null
}

init
download_source $PROG $PROG $DLVER
patch_source
prep_build
run_autoreconf
export LIBS="-lnsl"
build
install_smf system/virtualization open-vm-tools.xml
install_conf
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:fdm=marker
