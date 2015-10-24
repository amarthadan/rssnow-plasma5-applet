# RSSNOW for Plasma 5
This is a rewrite of RSSNOW plasmoid/applet compatible with Plasma 5

## Installation
### Arch Linux
Package for Arch Linux will be available shortly in [AUR](https://aur.archlinux.org/).

### Manual
##### Requirements
* [CMake](https://cmake.org/) (Arch Linux package `cmake`)
* [Extra CMake Modules](http://api.kde.org/ecm/manual/ecm.7.html) (Arch Linux package `extra-cmake-modules`)

```bash
$ git clone git://github.com/Misenko/rssnow-plasma5-applet
$ cd rssnow-plasma5-applet
$ cmake .
$ make
$ sudo make install
```
RSSNOW should be now available among your widgets and you can add it as usual.
