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

_cat_version() {
	cat $ROOT/version.txt
}

_git_check_master() {
	git submodule foreach --recursive git checkout master
}

_git_hash() {
	hash=`git log --pretty=oneline | cut -d ' ' -f1 | cut -d$'\n' -f1`
	hash6=${hash:0:4}
	echo ${hash6}
}

_git_pull_all() {
	git pull origin master
	git submodule foreach --recursive git pull origin master
}

_git_pull_origin_master() {
	git pull origin master
}

_git_status_all() {
	git submodule foreach --recursive git status 
	git status 
}

_nexync_backup() {
	cp -arpf source* Makefile* platform mk external internal /d/backup/
}

_source_file_rm() {
	rm ${SOURCE_DEP} ${MAKEFILE_DEP} ${PLATFORM_FILE}
}

_git_show_head_print() {
	#$1=project
	#$2=log
	local project=${1//"'"/""}
	printf "\e[1;34m%-30s\e[0m %s\n" "${project}" "${2}"
}

_git_show_head() {
	local logs=`git submodule foreach --recursive git log --oneline --decorate -1`
	#local logs=`git log --oneline --decorate -1`
	local count=0
	local project=""

	# show current project log
	_git_show_head_print "current" "`git log --oneline --decorate -1`"

	# show submodule log
	IFS=$'\n' b_array=(${logs})
	for i in "${b_array[@]}"
	do
		if [ $(((count+1)%2)) -eq 0 ]; then
			_git_show_head_print "${project}" "${i}"
		else
			project=`echo ${i} | cut -d' ' -f2`
		fi
		count=$((count+1))
	done
}

_git_show_log_submodules() {
	local logs=`git submodule foreach --recursive git log --oneline --decorate -5`
	#local logs=`git log --oneline --decorate -1`
	local count=0
	local project=""

	echo -e "\e[1;34mCurrent\e[0m"

	# show current project log
	git log --oneline --decorate -5

	# show submodule log
	IFS=$'\n' b_array=(${logs})
	for i in "${b_array[@]}"
	do
		local prj=`echo $i | grep "Entering"`
		if [ ! -z "$prj" ]; then
			prj=`echo ${i} | cut -d' ' -f2`
			prj=${prj//"'"/""}
			echo -e "\e[1;34m$prj\e[0m"
		else
			local hash=`echo ${i} | cut -d' ' -f1`
			local log=`echo ${i} | grep -o " .*"`
			echo -e "\e[0;33m$hash\e[0m"${log}
		fi
	done
}

_git_show_log() {
	# it's submodule mode
	if [ -z "$1" ];then
		_git_show_log_submodules
		exit
	fi

	# it's show by specified args
	for dir in "$@"
	do
		cd "${dir}"
		echo -e "\e[1;34m${dir}\e[0m"

		# show current project log
		git log --oneline --decorate -5
	done
}

_git_commit_push_origin_master() {
	git commit -a
	git push origin master
}

_git_show_details_log() {
	local path="$1"
	local prj="$2"
	local is_root=0

	# get ls-tree by parent path
	local ls_tree_commit_id="`git ls-tree @ "${prj}" | cut -d' ' -f3 `"
	ls_tree_commit_id=${ls_tree_commit_id:0:7}

	# is_root
	if [ "${path}" = "." ];then
		is_root=1
	fi

	# get HEAD by this project's path
	if [ $is_root -eq 0 ];then
		cd ${prj}
	fi
	local head_commit_log="`git log --oneline --decorate -1`"
	local head_commit_id=${head_commit_log:0:7}

	if [ $is_root -eq 1 ]; then
		# show root
		printf "\e[1;34m%-30s\e[0m _______ %s\n" "${path}" "${head_commit_log}"
	else
		# show submodule
		# give red color if ls-tree commit_id not equal head_commit_id
		if [ "${ls_tree_commit_id}" != "${head_commit_id}" ];then
			log="[1;5;34m${ls_tree_commit_id}\e[0m | ${head_commit_log}"
			printf "\e[1;34m%-30s\e[0m \e[1;31m%s\e[0m \e[1;31m%s\e[0m\n" "${path}" "${ls_tree_commit_id}" "${head_commit_log}"
		else
			printf "\e[1;34m%-30s\e[0m %s %s\n" "${path}" "${ls_tree_commit_id}" "${head_commit_log}"
		fi
	fi

	# get git status of renamed, new file, deleted, modified
	local status_log="`git status -uno | grep -e 'renamed:' -e 'new file:' -e 'deleted:' -e 'modified:'`"

	# do align
	if [ ! -z "${status_log}" ];then
		IFS=$'\n' b_array=(${status_log})
		for line in "${b_array[@]}"
		do
			line=${line//"	"/""}
			printf "%-30s \e[1;35m%s\e[0m\n" "" "${line}"
		done
	fi
	
	#if [ "${path}" != "." ];then
	if [ $is_root -eq 0 ];then
		cd ..
	fi
}

_git_show_details() {
	local path=$1
	local submodules=

	if [ -z "$path" ];then
		path="."
		_git_show_details_log "." "."
	fi

	# extract .gitmodules
	if [ -f ".gitmodules" ];then
		submodules="`cat .gitmodules`"
		IFS=$'\n' b_array=(${submodules})
		for i in "${b_array[@]}"
		do
			prj=`echo $i | grep "path = "`
			if [ ! -z "$prj" ]; then
				prj=${i//" "/""}
				prj=${prj//"	"/""}
				prj=`echo ${prj} | cut -d'=' -f2`

				# show ls-tree and HEAD of this submodule
				_git_show_details_log "${path}/${prj}" "${prj}"

				# process recursive
				cd ${prj}
				_git_show_details "${path}/${prj}"
				cd ..
			fi

#			these seen have program on mingw
#			# parse .gitmodules
#			local prj=`echo $i | grep "submodule"`
#			if [ ! -z "$prj" ]; then
#				prj=`echo ${i} | cut -d' ' -f2`
#				prj=${prj//"["/""}
#				prj=${prj//"]"/""}
#				prj=${prj//"\""/""}

#				# show ls-tree and HEAD of this submodule
#				_git_show_ls_tree_log "${path}/${prj}" "${prj}"

#				# process recursive
#				cd ${prj}
#				_git_show_ls_tree "${path}/${prj}"
#				cd ..
#			fi
		done
	fi
}

_alias() {
	alias cat_version="${MK}/helper.sh _cat_version"
	alias git_check_master="${MK}/helper.sh _git_check_master"
	alias git_hash="${MK}/helper.sh _git_hash"
	alias git_pull_all="${MK}/helper.sh _git_pull_all"
	alias git_pull_origin_master="${MK}/helper.sh _git_pull_origin_master"
	alias git_status_all="${MK}/helper.sh _git_status_all"
	alias git_show_head="${MK}/helper.sh _git_show_head"
	alias git_show_log="${MK}/helper.sh _git_show_log"
	alias git_show_details="${MK}/helper.sh _git_show_details"
	alias git_commit_push_origin_master="${MK}/helper.sh _git_commit_push_origin_master"
	alias nexync_backup="${MK}/helper.sh _nexync_backup"
	alias source_file_rm="${MK}/helper.sh _source_file_rm"
}
	
$@
