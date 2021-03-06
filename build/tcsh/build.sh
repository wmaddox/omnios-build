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
# Copyright 2017 OmniTI Computer Consulting, Inc.  All rights reserved.
# Copyright 2019 OmniOS Community Edition (OmniOSce) Association.

. ../../lib/functions.sh

PROG=tcsh
VER=6.21.00
VERHUMAN=$VER
PKG=shell/tcsh
SUMMARY="Tenex C-shell (tcsh)"
DESC="A Unix shell based on and compatible with the C shell (csh)"

UCPROG=${PROG^^}
UVER=${VER//./_}

set_builddir "$PROG-$UCPROG$UVER"
set_arch 64

init
download_source $PROG "$UCPROG$UVER"
patch_source
prep_build
build
run_testsuite check
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:fdm=marker
