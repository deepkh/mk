########################################################################### 
# 
# Copyright (c) Delta Electronics, Inc. All Right Reserved.
# Created by Gray Huang <gray.huang@deltaww.com> on 2017-08
#
# Redistribution and use in source and binary forms, with or without
# modification, are NOT permitted without specific written permission
# from above copyright holder.
#
##########################################################################

# Download toolchain for ARMv7 from here
# https://releases.linaro.org/components/toolchain/binaries/4.9-2017.01/arm-linux-gnueabihf/

export PATH=$PATH:/opt/toolchain/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf/bin
export ROOT=`pwd`
export MINGW_W64=arm-linux-gnueabihf
export CROSS_COMPILE1=$MINGW_W64-
export RUNTIME=$ROOT/runtime
export LD_LIBRARY_PATH=$RUNTIME/bin:$RUNTIME/lib
export PKG_CONFIG_PATH=$RUNTIME/lib/pkgconfig
export PATH=$PATH:$RUNTIME/bin

export BINSUFFIX=
export DLLSUFFIX="so"
export DLLASUFFIX="so"
export LDLLSUFFIX=

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


