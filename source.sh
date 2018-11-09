#!/bin/bash

export PLATFORM_FILE=".platform"
export SOURCE_DEP="source.dep.sh"
export MAKEFILE_DEP="Makefile.dep"

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
	export RUNTIME=$ROOT/runtime
	export RUNTIME_BIN=${RUNTIME}/bin
	export RUNTIME_LIB=${RUNTIME}/lib
	export RUNTIME_INCLUDE=${RUNTIME}/include
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

	# load global source.${PLATFORM}.sh
	source "${MK}/platform/source.${PLATFORM}.sh"

	# load helper alais
	source "${MK}/helper.sh" _alias

	# build source.deb.sh, Makefile.dep 
	source "${MK}/source.prebuild_dep.sh" "${SOURCE_DEP}" "${MAKEFILE_DEP}"

	# load source.deb.sh
	source ${SOURCE_DEP}

	# mkdir
	RUNTIME=$ROOT/runtime
	if [ ! -d "${RUNTIME}" ]; then
		${MKDIR} ${RUNTIME}
	fi
	if [ ! -d "${RUNTIME_BIN}" ]; then
		${MKDIR} ${RUNTIME_BIN}
	fi
	if [ ! -d "${RUNTIME_LIB}" ]; then
		${MKDIR} ${RUNTIME_LIB}
	fi
	if [ ! -d "${RUNTIME_INCLUDE}" ]; then
		${MKDIR} ${RUNTIME_INCLUDE}
	fi
	if [ ! -d "${RUNTIME}/share" ]; then
		${MKDIR} ${RUNTIME}/share
	fi
fi

