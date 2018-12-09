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
	printf "%-30s %s\n" "$project" "$2"
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

	echo -e "\e[1;5;34mCurrent\e[0m"

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
			echo -e "\e[1;5;34m$prj\e[0m"
		else
			local hash=`echo ${i} | cut -d' ' -f1`
			local log=`echo ${i} | grep -o " .*"`
			echo -e "\e[0;5;33m$hash\e[0m"${log}
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
		echo -e "\e[1;5;34m${dir}\e[0m"

		# show current project log
		git log --oneline --decorate -5
	done
}

_git_commit_push_origin_master() {
	git commit -a
	git push origin master
}

_git_ls_tree_master_submodules_show() {
	local path="$1"

	echo -e "\e[1;5;34m${path}\e[0m"

}

_git_ls_tree_master_submodules() {
	local path=$1
	local submodules=

	if [ -z "$path" ];then
		path="."
	fi
		
	_git_ls_tree_master_submodules_show ${path}

	if [ -f "${path}/.gitmodules" ];then
		

		submodules="`cat ${path}/.gitmodules`"
		IFS=$'\n' b_array=(${submodules})
		for i in "${b_array[@]}"
		do
			local prj=`echo $i | grep "submodule"`
			if [ ! -z "$prj" ]; then
				prj=`echo ${i} | cut -d' ' -f2`
				prj=${prj//"["/""}
				prj=${prj//"]"/""}
				prj=${prj//"\""/""}
				echo $prj
			fi
		done
	fi
}

#git submodule foreach --recursive git log --pretty=format:"%h; %cd; %s" -1
#echo "Entering 'libinternal/libnvenc_win32'" | cut -d' ' -f2

_alias() {
	alias cat_version="${MK}/helper.sh _cat_version"
	alias git_check_master="${MK}/helper.sh _git_check_master"
	alias git_hash="${MK}/helper.sh _git_hash"
	alias git_pull_all="${MK}/helper.sh _git_pull_all"
	alias git_status_all="${MK}/helper.sh _git_status_all"
	alias git_show_head="${MK}/helper.sh _git_show_head"
	alias git_show_log="${MK}/helper.sh _git_show_log | less -R"
	alias git_commit_push_origin_master="${MK}/helper.sh _git_commit_push_origin_master"
	alias git_ls_tree_master_submodules="${MK}/helper.sh _git_ls_tree_master_submodules"
	alias nexync_backup="${MK}/helper.sh _nexync_backup"
	alias source_file_rm="${MK}/helper.sh _source_file_rm"
	alias HHHH="ls -al"
}
	
$@
