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

export HOST=`uname`
export PLATFORM_FILE=".platform"

_get_platform_result=
_get_platform() {
	local platform_array=("mingw" "mingw.linux" "linux" "arm-linux-gnueabihf", "mac")
	echo "Select Platform"
	select yn in ${platform_array[@]} ; do
		case $yn in
			"${platform_array[0]}" ) _get_platform_result=${yn}; break;;
			"${platform_array[1]}" ) _get_platform_result=${yn}; break;;
			"${platform_array[2]}" ) _get_platform_result=${yn}; break;;
			"${platform_array[3]}" ) _get_platform_result=${yn}; break;;
			"${platform_array[4]}" ) _get_platform_result=${yn}; break;;
		esac
	done
}

unset ROOT
export CROSS_COMPILE_MODE="0"

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
	export MK_SCRIPT="${ROOT}/mk/Makefile.mk_script"
	echo "MK=${MK}"

	if [ "${HOST:0:10}" = "MINGW32_NT" ];then
		export HOST="${HOST:0:10}"
	fi
	echo "HOST=${HOST}"

	if [ "${PF}" = "" ];then
		# get PLATFORM
		if [ ! -f "${PLATFORM_FILE}" ]; then
			_get_platform 
			echo "${_get_platform_result}" > "${PLATFORM_FILE}"
		fi
		export PLATFORM=`cat ${PLATFORM_FILE}`
	else
		export PLATFORM="${PF}"
	fi
	echo "PLATFORM=${PLATFORM}"

	# get TARGET
	if [[ "${PLATFORM}" = "mingw" || "${PLATFORM}" = "mingw.linux" ]];then
		export TARGET="win64"
	elif [ "${PLATFORM}" = "linux" ];then
		export TARGET="linux64"
	elif [ "${PLATFORM}" = "arm-linux-gnueabihf" ];then
		export TARGET="armv7"
	elif [ "${PLATFORM}" = "mac" ];then
		export TARGET="mac64"
	fi

	echo "TARGET=${TARGET}"

	# check CROSS_COMPILE_MODE
	if [[ "${HOST}" = "Linux"  && "${TARGET}" != "linux64" ]];then
		export CROSS_COMPILE_MODE="1"
	fi

	if [[ "${HOST}" = "MINGW32_NT"  && "${TARGET}" != "win64" ]];then
		export CROSS_COMPILE_MODE="1"
	fi

	echo CROSS_COMPILE_MODE=${CROSS_COMPILE_MODE}

	# export source.dep.linux-Linux, Makefile.dep.linux-Linux
	export PLATFORM_HOST="${PLATFORM}-${HOST}"
	export SOURCE_DEP="source.dep.${PLATFORM_HOST}"
	export MAKEFILE_DEP="Makefile.dep.${PLATFORM_HOST}"

	# export runtime.host.${HOST}
	#export RUNTIME_HOST=$ROOT/runtime.host.${HOST}
	#export RUNTIME_HOST_BIN=${RUNTIME_HOST}/bin
	#export RUNTIME_HOST_LIB=${RUNTIME_HOST}/lib
	#export RUNTIME_HOST_OBJS=${RUNTIME_HOST}/objs
	#export RUNTIME_HOST_INCLUDE=${RUNTIME_HOST}/include

	# export runtime.${TARGET}
	export RUNTIME=$ROOT/runtime.${TARGET}
	export RUNTIME_BIN=${RUNTIME}/bin
	export RUNTIME_LIB=${RUNTIME}/lib
	if [[ "${PLATFORM}" = "mingw" || "${PLATFORM}" = "mingw.linux" ]];then
		export RUNTIME_DLL=${RUNTIME}/bin
		export RUNTIME_DLL_A=${RUNTIME}/lib
	else
		export RUNTIME_DLL=${RUNTIME}/lib
		export RUNTIME_DLL_A=${RUNTIME}/lib
	fi
	export RUNTIME_OBJS=${RUNTIME}/objs
	export RUNTIME_INCLUDE=${RUNTIME}/include

	# load global source.${PLATFORM}.sh
	source "${MK}/platform/source.${PLATFORM}.sh"

	# build source.deb.sh, Makefile.dep 
	source "${MK}/source.prebuild_dep.sh" "${SOURCE_DEP}" "${MAKEFILE_DEP}" "${HOST}"

	# load source.deb.sh
	source ${SOURCE_DEP}

	# mkdir
	dirs=("${RUNTIME}" "${RUNTIME_BIN}" "${RUNTIME_LIB}" "${RUNTIME_INCLUDE}" "${RUNTIME}/share" "${RUNTIME_OBJS}")
		#"${RUNTIME_OBJS}" \
		#"${RUNTIME_HOST}")
		#"${RUNTIME_HOST}" "${RUNTIME_HOST_BIN}" "${RUNTIME_HOST_LIB}" "${RUNTIME_HOST_INCLUDE}" "${RUNTIME_HOST_OBJS}" "${RUNTIME_HOST}/share")
	for dir in "${dirs[@]}"
	do
		if [ ! -d "${dir}" ]; then
			${MKDIR} ${dir}
		fi
	done
fi

