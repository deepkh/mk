### NetSync.tv Third-party library build scripts
### Grey Huang <deepkh@gmail.com>
### 2016
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

_alias() {
	alias cat_version="${MK}/helper.sh _cat_version"
	alias git_check_master="${MK}/helper.sh _git_check_master"
	alias git_hash="${MK}/helper.sh _git_hash"
	alias git_pull_all="${MK}/helper.sh _git_pull_all"
	alias git_status_all="${MK}/helper.sh _git_status_all"
	alias nexync_backup="${MK}/helper.sh _nexync_backup"
	alias source_file_rm="${MK}/helper.sh _source_file_rm"
	alias HHHH="ls -al"
}
	
$@
