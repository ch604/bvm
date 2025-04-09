# bvm
bvm - bash version manager

install and use various versions of bash for testing, written in bash!

# wuzzit do
* list and install/remove various bash versions from ftp.gnu.org
* list locally installed bash versions
* enter bash shells or execute scripts directly by passing arguments
* updating installer script and compact install in ~/.bvm

# how to install or update
firstly, ensure you have the ability to build c by installing `build-utils` or `cpp`. you will also need `wget` to pull bash source files, and for some versions of bash you will also need `byacc` installed. then, run the installer:
```
bash < <(curl -s https://raw.githubusercontent.com/ch604/bvm/refs/heads/main/install.sh)
```

if you need to adjust where your files live, download install.sh instead and change BVM_INSTALLDIR before executing. to update, just run the install script again.

# how to use
at first run, source your linux user's .bashrc:
```
source ~/.bashrc
```
... or close and repoen your terminal. then:
```
bvm -h
```

# how to uninstall
remove the entire ~/.bvm directory.