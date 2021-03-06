# Copyright (c) 2018, Gary Huang, deepkh@gmail.com, https://github.com/deepkh
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

export MINGW_W64=i686-w64-mingw32
export CROSS_COMPILE1=$MINGW_W64-
export PKG_CONFIG_PATH=$RUNTIME/lib/pkgconfig
export PATH=$RUNTIME/bin:$PATH

export HOST_BINSUFFIX=".exe"
export HOST_DLLSUFFIX="dll"
export HOST_DLLASUFFIX="dll.a"
export HOST_LDLLSUFFIX=".dll"
export HOST_DEFSUFFIX="def"
export HOST_LIBSUFFIX="a"

export BINSUFFIX=".exe"
export DLLSUFFIX="dll"
export DLLASUFFIX="dll.a"
export LDLLSUFFIX=".dll"
export DEFSUFFIX="def"
export LIBSUFFIX="a"

export CP="cp -arpf"
export RM="rm -rf"
export MV="mv"
export MKDIR="mkdir -p"
export MAKE="make"
export CD="cd"
export CC=$CROSS_COMPILE1"gcc"
export CXX=$CROSS_COMPILE1"g++"
export STRIP=$CROSS_COMPILE1"strip"
export AR=$CROSS_COMPILE1"ar"
export WINDRES=$CROSS_COMPILE1"windres"
export TAR="tar"
export WGET="wget --no-check-certificate"

export HAVE_DEF_DEBUG=1
export HAVE_DEF_STATIC=1
export HAVE_DEF_SSE=1
export HAVE_DEF_FPIC=
export HAVE_DEF_FILE_OFFSET_BITS_64=1
export HAVE_DEF_LARGEFILE64_SOURCE=1
export HAVE_DEF_WINVER="_WIN32_WINNT_WIN7"
export HAVE_DEF_WIN32_WINNT="0x0601"

export HAVE_LIB_WIN32=1
export HAVE_LIB_PTHREAD=
export HAVE_LIB_DL=
export HAVE_LIB_RT=

