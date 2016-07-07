name "supervisor"
default_version "3.3.0"

# see https://pypi.python.org/pypi/supervisor
source url: "https://pypi.python.org/packages/44/80/d28047d120bfcc8158b4e41127706731ee6a3419c661e0a858fb0e7c4b2d/supervisor-3.3.0.tar.gz",
       md5: "46bac00378d1eddb616752b990c67416"

dependency "python"
dependency "pip"

relative_path "supervisor-#{version}"

build do
  command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"

  # Build files (config, init script, etc...)
  # inspired by https://github.com/treasure-data/omnibus-td-agent/blob/master/config/software/td-agent-files.rb
  block do
    pkg_type = project.packager.id.to_s
    root_path = "/" # for ERB
    install_path = project.install_dir # for ERB
    project_name = project.name # for ERB
    project_name_snake = project.name.gsub('-', '_') # for variable names in ERB

    template = ->(*parts) { File.join('templates', *parts) }
    generate_from_template = ->(dst, src, erb_binding, opts={}) {
      mode = opts.fetch(:mode, 0755)
      FileUtils.mkdir_p File.dirname(dst)
      File.open(dst, 'w', mode) do |f|
        f.write ERB.new(File.read(src)).result(erb_binding)
      end
    }

    # setup init.d file
    # templates/etc/init.d/xxx/supervisord -> ./opt/supervisor/etc/init.d/supervisord
    initd_file_path = File.join(install_path, 'etc', 'init.d', 'supervisord')
    generate_from_template.call initd_file_path, template.call('etc', 'init.d', 'supervisord'), binding, mode: 0755

    # logrotate.d
    # templates/etc/logrotate.d/supervisor -> ./opt/supervisor/etc/logrotate.d/supervisor
    logrotate_path = File.join(install_path, 'etc', 'logrotate.d', 'supervisor')
    generate_from_template.call logrotate_path, template.call('etc', 'logrotate.d', 'supervisor'), binding, mode: 0644

    # supervisord.conf
    # templates/etc/supervisord.conf -> ./opt/supervisor/etc/supervisord.conf
    logrotate_path = File.join(install_path, 'etc', 'supervisord.conf')
    generate_from_template.call logrotate_path, template.call('etc', 'supervisord.conf'), binding, mode: 0644

    # supervisord.service
    # templates/usr/lib/systemd/system/supervisord.service -> ./opt/supervisor/usr/lib/systemd/system/supervisord.service
    logrotate_path = File.join(install_path, 'usr', 'lib', 'systemd', 'system', 'supervisord.service')
    generate_from_template.call logrotate_path, template.call('usr', 'lib', 'systemd', 'system', 'supervisord.service'), binding, mode: 0644

  end
end
