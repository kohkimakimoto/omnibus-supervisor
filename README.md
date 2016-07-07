# Omnibus Supervisor

Creating full-stack platform-specific packages for `supervisor`. Packages created by this project replace the standard `supervisor` packages.

## Requirements

* Vagrant
* VirtualBox

## Usage

build packages:

```
make
```

destroy VMs:

```
make destroy
```

## Supported platforms

* CentOS5
* CentOS6
* CentOS7

## See also

* [README.omnibus.md](README.omnibus.md)
* [chef/omnibus](https://github.com/chef/omnibus)
* [supervisord.org](http://supervisord.org/)
