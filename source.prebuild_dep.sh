#!/bin/bash

SOURCE_DEP="$1"
MAKEFILE_DEP="$2"
#echo ${SOURCE_DEP} ${MAKEFILE_DEP}

# find find recursive and return dir list where contain the filter file 
_find_file_recursive_results=
_find_file_recursive() {
	local _a=("$@")
	local _path="${_a[0]}"
	local _filter=${_a[1]}
	local _counter=${_a[2]}
	local _cb=${_a[3]}
#	local found=

	#echo "_path:${_path}"
	#echo "_filter:${_filter}"
	#echo "_counter:${_counter}"
	#echo " "

	# clear var
	if [ ${_counter} -eq 0 ];then
		_find_file_recursive_results=
	fi

	# if found filtered file in this path
	if [ -f "${_path}/${_filter}" ]; then
		_find_file_recursive_results+="${_path}\n"
		echo "FOUND ${_counter} ${_path}/${_filter}"
	fi

	# traverse non hidden dir 
	for f in "${_path}"/*
	do
#		if [ -f "${f}" ]; then
#			# not consider root path
#			if [ $found -eq 0 ] && echo "${f}" | grep -q "${_filter}"; then
#				_find_file_recursive_results+="${_path}\n"
#				echo "FOUND ${_counter} ${_path}"
#				found="${_path}\n"
#			fi
#		else
			if [ -d "${f}" ]; then
				_find_file_recursive "${f}" ${_filter} $((_counter+1)) ${_cb}
			fi
#		fi
	done

	# done callback
	if [ ${_counter} -eq 0 ];then
		${_cb} "${_root_path_have_filter_file}${_find_file_recursive_results}"
	fi
}

_prebuild_source_makefile_dep() {
	echo done
	local paths=$(echo -e ${@} | tr ";" "\n")

	for path in ${paths}
	do
		local source="${path}/source.sh"
		local makefile="${path}/Makefile.inc"
    	#echo "> [$path]"

		if [ -f "${source}" ]; then
			echo "source ${source} \"$path\"" >> ${SOURCE_DEP}
		fi
		
		if [ -f "${makefile}" ]; then
			echo "include ${makefile}" >> ${MAKEFILE_DEP}
		fi
	done
}

#rm ${SOURCE_DEP} 2> /dev/null
#rm ${MAKEFILE_DEP} 2> /dev/null  

# if not exists, then create one
if [ ! -f ${SOURCE_DEP} ] || [ ! -f ${MAKEFILE_DEP} ]; then
	echo "Building source.dep.sh and Makefile.dep"
	# clear
	echo "# May need adjustment the order manually." >  ${SOURCE_DEP}
	echo "" > ${MAKEFILE_DEP}
	PWD="`pwd`"
	_find_file_recursive "${PWD}" Makefile.inc 0 _prebuild_source_makefile_dep
	chmod +x ${SOURCE_DEP}
fi

