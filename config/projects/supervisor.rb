name "supervisor"
maintainer "Kohki Makimoto"
homepage "https://github.com/kohkimakimoto/omnibus-supervisor"
description "A System for Allowing the Control of Process State on UNIX"

# Defaults to C:/supervisor on Windows
# and /opt/supervisor on all other platforms
install_dir "#{default_root}/#{name}"

# build_version Omnibus::BuildVersion.semver
build_version "3.3.0"
build_iteration 1

# Creates required build directories
dependency "preparation"

# supervisor dependencies/components
dependency "supervisor"

# version manifest file
dependency "version-manifest"

exclude "**/.git"
exclude "**/bundler/git"
