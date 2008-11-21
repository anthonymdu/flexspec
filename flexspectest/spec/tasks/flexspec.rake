require 'fileutils'
require File.dirname(__FILE__) + '/config'

namespace :flexspec do
  desc "Updates the flexspec code"
  task :update => 'cache:update' do
    # pull down a fresh install, use that to update
    local_path = Dir.pwd
    Dir.chdir(File.join(flexspec_config.local_cache, 'flexspec')) do
      system("rake flexspec:update_install update_target=\"#{local_path}\"")
    end
  end

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
        system("git clone #{flexspec_config.repo_location} #{flexspec_config.local_cache}")
      end
    end

    desc "Removes the local cache of the flexspec code"
    task :clear do
      rm_rf(flexspec_config.local_cache)
    end
  end

  desc "Usually ran during an update, this updates the code from a checkout into a flexspec install"
  task :update_install do
    puts "Updating install at #{flexspec_config.install_location}"
    # rm_rf(flexspec_config.install_location)
    
    flexspec_config.files_of_interest.each do |file|
      cp_r(file, flexspec_config.install_location)
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
  def install_location
    File.join(update_target, 'spec')
  end
end

FlexspecConfig.configure do |config|
  # config.add(:install_location, :default => 'spec')
  config.add(:repo_location, :default => 'git://github.com/moneypools/flexspec.git')
  config.add(:files_of_interest, :default => ['tasks'])
  config.add(:local_cache, :default => File.join('tmp', 'flexspec'))
  config.add(:update_target)
end

def flexspec_config
  FlexspecConfig.instance
end