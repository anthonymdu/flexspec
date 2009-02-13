require 'fileutils'
require File.dirname(__FILE__) + '/config'

namespace :flexspec do
  desc "Updates the flexspec code"
  task :update => ['cache:update', 'do_install_update']

  namespace :cache do
    desc "Updates the local cache of the flexspec code"
    task :update do
      if File.exists?(flexspec_config.local_cache) && (current_cache_repo_location == flexspec_config.repo_location)
        puts "Updating flexspec cache at #{flexspec_config.local_cache}"
        Dir.chdir(flexspec_config.local_cache) do
          system("git pull")
        end
      elsif File.exists?(flexspec_config.local_cache)
        puts "Removing old flexspec cache (#{current_cache_repo_location}) and replacing it with #{flexspec_config.repo_location}"
        rm_rf(flexspec_config.local_cache)
        system("git clone #{flexspec_config.repo_location} #{flexspec_config.local_cache}")
      else
        puts "Doing initial clone of #{flexspec_config.repo_location} to #{flexspec_config.local_cache}"
        system("git clone --depth 1 #{flexspec_config.repo_location} #{flexspec_config.local_cache}")
      end
    end

    desc "Removes the local cache of the flexspec code"
    task :clear do
      rm_rf(flexspec_config.local_cache)
    end
  end

  # Kept for legacy reasons
  # desc "Usually ran during an update, this updates the code from a checkout into a flexspec install"
  task :update_install do
    Dir.chdir(flexspec_config.update_target) do 
      Rake::Task['flexspec:do_install_update'].invoke
    end
  end

  task :do_install_update do
    puts "#{Dir.pwd}"
    puts "#{File.expand_path(File.join(flexspec_config.flex_spec_cache_location, 'tasks', 'flexspec.install'))}"
    load File.join(flexspec_config.flex_spec_cache_location, 'tasks', 'flexspec.install')

    flexspec_config.update_target = Dir.pwd
    Dir.chdir(flexspec_config.flex_spec_cache_location) do
      Rake::Task['flexspec:update_install'].invoke
    end
  end

  def current_cache_repo_location
    Dir.chdir(flexspec_config.local_cache) do
      show_info = %x[git remote show origin -n]
      show_info.match(/^.*URL: (.*)/)[1].chomp
    end
  end
end

class FlexspecConfig < Rake::Config
  def flex_spec_cache_location
    File.join(local_cache, 'flexspec')
  end

  def install_location
    File.join(update_target, 'spec')
  end

  def libs_path
    File.join(update_target, libs_dir_name)
  end
end

FlexspecConfig.configure do |config|
  # config.add(:install_location, :default => 'spec')
  config.add(:libs_dir_name, :default => 'lib')
  config.add(:repo_location, :default => 'git://github.com/moneypools/flexspec.git')
  config.add(:files_of_interest, :default => ['tasks', 'includes', 'mock_templates'])
  config.add(:swc_file, :default => File.join('bin', 'flexspec.swc'))
  config.add(:local_cache, :default => File.join('tmp', 'flexspec'))
  config.add(:update_target)
end

def flexspec_config
  FlexspecConfig.instance
end