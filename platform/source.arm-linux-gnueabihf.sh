### NetSync.tv Third-party library build scripts
### Grey Huang <deepkh@gmail.com>
### 2016

# Download toolchain for ARMv7 from here
# https://releases.linaro.org/components/toolchain/binaries/4.9-2017.01/arm-linux-gnueabihf/

export PATH=$PATH:/opt/toolchain/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf/bin
export MINGW_W64=arm-linux-gnueabihf
export CROSS_COMPILE1=$MINGW_W64-
export RUNTIME=$ROOT/runtime
export LD_LIBRARY_PATH=$RUNTIME/bin:$RUNTIME/lib
export PKG_CONFIG_PATH=$RUNTIME/lib/pkgconfig
export PATH=$RUNTIME/bin:$PATH

export BINSUFFIX=
export DLLSUFFIX="so"
export DLLASUFFIX="so"
export LDLLSUFFIX=
export DEFSUFFIX=
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

export HAVE_DEF_DEBUG=
export HAVE_DEF_STATIC=
export HAVE_DEF_SSE=
export HAVE_DEF_FPIC=1
export HAVE_DEF_FILE_OFFSET_BITS_64=1
export HAVE_DEF_LARGEFILE64_SOURCE=1
export HAVE_DEF_WINVER=
export HAVE_DEF_WIN32_WINNT=

export HAVE_LIB_WIN32=
export HAVE_LIB_PTHREAD=1
export HAVE_LIB_DL=1
export HAVE_LIB_RT=1


