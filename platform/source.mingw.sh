### NetSync.tv Third-party library build scripts
### Grey Huang <deepkh@gmail.com>
### 2016

export MINGW_W64=i686-w64-mingw32
export CROSS_COMPILE1=$MINGW_W64-
#export RUNTIME=$ROOT/runtime
export PKG_CONFIG_PATH=$RUNTIME/lib/pkgconfig
export PATH=$PATH:$RUNTIME/bin:$RUNTIME/lib

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

