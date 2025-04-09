#!/bin/bash
# bvm - bash version manager
# v1.0.0
# github.com/ch604/bvm

_bvm_help() {
	cat <<-EOF

	   bash version manager
	
	Usage:
	bvm [-h|-l|-L|-a ver|-r ver|-e ver [...]]

	Arguments:
	-e ver [args]	enter a shell for the version of bash specified.
	 	 	additional arguments are acceptable to, for
	 	 	instance, execute a script.
	-h		display this help text
	-l		list installed bash versions
	-L		list available bash versions on ftp.gnu.org
	-a ver		add/install a version of bash
	-r ver		remove/uninstall a version of bash

	EOF
}

_bvm_enter() {
	if [[ -z "$1" || ! -d "$BVM_INSTALLDIR/bash-$1" || ! -x "$BVM_INSTALLDIR/bash-$1/bash" ]]; then
		_bvm_help
		return 1
	else
		local _ver="$1"
		shift
		env -i PATH="$BVM_INSTALLDIR:$PATH" "$BVM_INSTALLDIR/bash-$_ver/bash" --noprofile --norc "$@"
	fi
}

_bvm_add_version() {
	if [[ -z "$1" ]]; then
		_bvm_help
		return 1
	elif _bvm_list_installed | grep -qx "$1"; then
		echo -e "Bash version $1 is already installed!\n\nInstalled versions:\n"
		_bvm_list_installed | column
		return 1
	fi
	local _list _build_output
	_list=$(_bvm_list_available)
	if ! grep -qx "$1" <<< "$_list"; then
		echo -e "Bash version $1 is not available from ftp.gnu.org!\n\nAvailable versions:\n"
		echo "$_list"
		return 1
	fi
	echo "Installing Bash version $1 from ftp.gnu.org..."
	wget -q "https://ftp.gnu.org/gnu/bash/bash-$1.tar.gz" -P "$BVM_INSTALLDIR"
	tar -zxf "$BVM_INSTALLDIR/bash-$1.tar.gz" -C "$BVM_INSTALLDIR"
	rm -f "${BVM_INSTALLDIR:?}/bash-${1:?}.tar.gz"
	pushd "$BVM_INSTALLDIR/bash-$1" || return 1
	_build_output=$(mktemp)
	(./configure && make) &> "$_build_output"
	popd || return 1
	if [ -x "$BVM_INSTALLDIR/bash-$1/bash" ]; then
		echo "Success! Run \`bvm -e $1\` to enter this shell."
		rm -f "${_build_output:?}"
	else
		echo "Failure! I couldn't find $BVM_INSTALLDIR/bash-$1/bash. Please tail $_build_output for build details."
	fi
}

_bvm_remove_version() {
	if [[ -z "$1" ]]; then 
		_bvm_help
		return 1
	elif ! _bvm_list_installed | grep -qx "$1"; then
		echo -e "Bash version $1 is not installed!\n\nInstalled versions:\n"
		_bvm_list_installed | column
		return 1
	fi
	if [ -d "$BVM_INSTALLDIR/bash-$1" ]; then
		echo "Removing bvm Bash version $1..."
		rm -rf "${BVM_INSTALLDIR:?}/bash-${1:?}"
	fi
}

_bvm_list_installed() {
	find "$BVM_INSTALLDIR" -maxdepth 1 -type d -name "bash-[0-9]*" -printf "%f\n" | \
	awk -F- '{print $NF}'
}

_bvm_list_available() {
	curl -s https://ftp.gnu.org/gnu/bash/ | \
	grep -o '<a href="bash-[0-9][^"]*.tar.gz"' | \
	sed -e 's/^<a href="bash-//' -e 's/.tar.gz"$//'
}
