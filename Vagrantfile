# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

#
# Vagrant confiugre
#
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

%w{
    centos-5.11
    centos-6.7
    centos-7.2
  }.each_with_index do |platform, index|

    config.vbguest.auto_update = false
    config.vm.define platform do |c|
      c.vm.box = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_#{platform}_chef-provisionerless.box"
      c.vm.network :private_network, type: "dhcp"

      case platform
      when /^centos-5/
        extra_packages = "gcc44 gcc44-c++"
      when /^centos-6/
        extra_packages = ""
      when /^centos-7/
        extra_packages = ""
      else
        raise "Unsupported platform: #{platform}"
      end

      c.vm.provision :shell, :inline => <<-EOT
        # epel repo
        yum -y install epel-release

        # packages
        yum -y install #{extra_packages} \
          perl-ExtUtils-MakeMaker \
          git \
          make \
          man \
          bzip2 \
          autoconf \
          automake \
          libtool \
          bison \
          gcc-c++ \
          patch \
          readline \
          readline-devel \
          expat-devel \
          gettext-devel \
          curl-devel \
          openssl-devel \
          zlib \
          zlib-devel \
          libffi-devel \
          gdbm-devel \
          libxslt-devel \
          libxml2-devel \
          fakeroot \
          rpm-build

        # update git from source (git is too old in centos6!)
        cd /tmp
        curl -OL https://github.com/git/git/archive/v2.7.4.tar.gz
        tar -zxf v2.7.4.tar.gz
        cd git-2.7.4
        make configure
        ./configure  --prefix=/usr
        make all
        make install
        hash -r

        #
        # Some packages can not be downloaded by issue of SSL on CentOS5.
        # So, copy the package files which are downloaded before to the cache directory.
        #
        # see also https://github.com/chef/omnibus/issues/531
        #
        mkdir -p /var/cache/omnibus/cache
        cp /vagrant/.tmp/* /var/cache/omnibus/cache/

        # rbenv and ruby
        git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
        echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
        echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
        cd
        source .bash_profile
        git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
        rbenv install 2.2.1
        rbenv global 2.2.1
        hash -r

        # gem
        gem install bundler
        gem install omnibus

        cd /vagrant
        bundle install --system --binstubs
        bin/omnibus build supervisor
      EOT

      c.vm.provider :virtualbox do |vb|
        vb.gui = false
        vb.customize ["modifyvm", :id, "--memory", "2048"]
      end

    end

  end

end
