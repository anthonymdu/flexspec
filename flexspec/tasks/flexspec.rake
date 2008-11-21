require 'fileutils'

namespace :flexspec do
  task :update do
    puts "Updating flexspec cache at #{flexspec_config.local_cache}"
    system("git clone #{flexspec_config.repo_location} #{flexspec_config.local_cache}")
    Dir.chdir(flexspec_config.local_cache) do
      system("git pull")
    end

    # rm_rf(flexspec_config.install_location)
    flexspec_config.files_of_interest.each do |file|
      cp_r(File.join(flexspec_config.local_cache, file), flexspec_config.install_location)
    end
  end

  def flexspec_config
    FlexspecConfig.instance
  end
end

class FlexspecConfig
  include Singleton

  {:install_location => 'spec',
   :repo_location => 'git://github.com/moneypools/funfx.git',
   :local_cache => File.join('tmp', 'flexspec'),
   :files_of_interest => [File.join('flexspec', 'tasks')]}.each_pair do |setting, default|

    attr_writer setting
    define_method(setting) do
      instance_variable_get("@#{setting}") || default
    end
  end
end