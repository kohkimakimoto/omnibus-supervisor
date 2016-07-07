.PHONY: default prepare build build_centos5 build_centos6 build_centos7

default: build

prepare:
	@echo "preparing..."
	cd $(CURDIR)/.tmp && \
		curl -L -O https://www.openssl.org/source/openssl-1.0.1t.tar.gz && \
		curl -L -O http://downloads.sourceforge.net/project/libpng/zlib/1.2.8/zlib-1.2.8.tar.gz

build: clean prepare
	@echo "building..."
	vagrant destroy -f
	vagrant up
	vagrant halt

build_centos5: prepare
	@echo "building..."
	vagrant destroy centos-5.11 -f
	vagrant up centos-5.11
	vagrant halt centos-5.11

build_centos6: prepare
	@echo "building..."
	vagrant destroy centos-6.7 -f
	vagrant up centos-6.7
	vagrant halt centos-6.7

build_centos7: prepare
	@echo "building..."
	vagrant destroy centos-7.2 -f
	vagrant up centos-7.2
	vagrant halt centos-7.2

destroy:
	vagrant destroy -f

clean:
	rm -rf $(CURDIR)/pkg
