# bvm
bvm - bash version manager

install and use various versions of bash for testing, written in bash!

# how to install or update
firstly, ensure you have the ability to build c by installing `build-utils` or `cpp`. you will also need `wget` to pull bash source files, and for some versions of bash you will also need `byacc` installed. then, run the installer:
```
bash < <(curl -s https://raw.githubusercontent.com/ch604/bvm/refs/heads/main/install.sh)
```

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