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
#!/bin/bash

export UNAME=`uname`
export PLATFORM_FILE=".platform.${UNAME}"

_get_platform_result=
_get_platform() {
	local platform_array=("mingw" "mingw.linux" "linux" "arm-linux-gnueabihf")
	echo "Select Platform"
	select yn in ${platform_array[@]} ; do
		case $yn in
			"${platform_array[0]}" ) _get_platform_result=${yn}; break;;
			"${platform_array[1]}" ) _get_platform_result=${yn}; break;;
			"${platform_array[2]}" ) _get_platform_result=${yn}; break;;
			"${platform_array[3]}" ) _get_platform_result=${yn}; break;;
		esac
	done
}

unset ROOT

if [ -z $ROOT ]; then
	export ROOT=`pwd`
	export MK="${ROOT}/mk"
	export MK_JOBS=-j8
	export MK_RESET="${ROOT}/mk/Makefile.reset"
	export MK_COMMON="${ROOT}/mk/Makefile.common"
	export MK_BIN="${ROOT}/mk/Makefile.mk_bin"
	export MK_DLL="${ROOT}/mk/Makefile.mk_dll"
	export MK_LIB="${ROOT}/mk/Makefile.mk_lib"
	export MK_HEADER="${ROOT}/mk/Makefile.mk_header"
	export MK_DIR="${ROOT}/mk/Makefile.mk_dir"
	export MK_PKG="${ROOT}/mk/Makefile.mk_pkg"
	echo "MK=${MK}"

	# get platform
	if [ ! -f "${PLATFORM_FILE}" ]; then
		_get_platform 
		echo "${_get_platform_result}" > "${PLATFORM_FILE}"
	fi
	export PLATFORM=`cat ${PLATFORM_FILE}`
	echo "PLATFORM=${PLATFORM}"

	# export source.dep.linux-Linux, Makefile.dep.linux-Linux
	export PLATFORM_HOST="${PLATFORM}-${UNAME}"
	export SOURCE_DEP="source.dep.${PLATFORM_HOST}"
	export MAKEFILE_DEP="Makefile.dep.${PLATFORM_HOST}"
	
	# export runtime.linux-Linux
	unset RUNTIME
	export RUNTIME=$ROOT/runtime.${PLATFORM_HOST}
	echo XXXXXXXXXXXXXXXXXXXXX${RUNTIME}
	export RUNTIME_BIN=${RUNTIME}/bin
	export RUNTIME_LIB=${RUNTIME}/lib
	export RUNTIME_INCLUDE=${RUNTIME}/include

	# load global source.${PLATFORM}.sh
	source "${MK}/platform/source.${PLATFORM}.sh"

	# load helper alais
	source "${MK}/git_helper.sh" _alias

	# build source.deb.sh, Makefile.dep 
	source "${MK}/source.prebuild_dep.sh" "${SOURCE_DEP}" "${MAKEFILE_DEP}" "${UNAME}"

	# load source.deb.sh
	source ${SOURCE_DEP}

	# mkdir
	dirs=("${RUNTIME}" "${RUNTIME_BIN}" "${RUNTIME_LIB}" "${RUNTIME_INCLUDE}" "${RUNTIME}/share")
	for dir in "${dirs[@]}"
	do
		if [ ! -d "${dir}" ]; then
			${MKDIR} ${dir}
		fi
	done
fi

