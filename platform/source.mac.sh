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

#export MINGW_W64=i686-w64-mingw32
#export CROSS_COMPILE1=$MINGW_W64-
export DYLD_LIBRARY_PATH=$RUNTIME/bin:$RUNTIME/lib
export PKG_CONFIG_PATH=$RUNTIME/lib/pkgconfig
export PATH=$RUNTIME/bin:$PATH

export BINSUFFIX=
export DLLSUFFIX="dylib"
export DLLASUFFIX="dylib"
export LDLLSUFFIX=
export DEFSUFFIX=
export LIBSUFFIX="a"

export CP="cp -aRpf"
export RM="rm -rf"
export MV="mv"
export MKDIR="mkdir -p"
export MAKE="make"
export CD="cd"
export CC=$CROSS_COMPILE1"gcc"
export CXX=$CROSS_COMPILE1"g++"
export STRIP=$CROSS_COMPILE1"strip"
export AR=$CROSS_COMPILE1"ar"
export TAR="tar"
export WGET="wget --no-check-certificate"

export HAVE_DEF_DEBUG=1
export HAVE_DEF_STATIC=
export HAVE_DEF_SSE=1
export HAVE_DEF_FPIC=1
export HAVE_DEF_FILE_OFFSET_BITS_64=1
export HAVE_DEF_LARGEFILE64_SOURCE=
export HAVE_DEF_WINVER=
export HAVE_DEF_WIN32_WINNT=

export HAVE_LIB_WIN32=
export HAVE_LIB_PTHREAD=1
export HAVE_LIB_DL=1
export HAVE_LIB_RT=

