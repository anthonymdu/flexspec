require File.dirname(__FILE__) + '/config'
require 'fileutils'

namespace :mock do
  task :build do
    # clean out and re-create the output dir
    rm_r(mock_config.output_dir)
    FileUtils.mkdir_p(mock_config.output_dir)

    system("asdoc -source-path #{mock_config.source_path} -doc-sources #{mock_config.doc_sources} -external-library-path+=#{mock_config.external_library_path} -templates-path #{mock_config.templates_path} -output #{mock_config.output_dir}")
    
    # now kill off a bunch of extra junk asdoc creates that we don't want
    %w(all-classes appendixes class-summary index-list index mxml-tags package-frame package-list package-summary title-bar).each do |html_page|
      rm(File.join(mock_config.output_dir, "#{html_page}.html"))
    end
    rm_r(File.join(mock_config.output_dir, 'images'))
  end
end

class MockConfig < Rake::Config
end

MockConfig.configure do |config|
  config.add(:templates_path, :default => File.join(File.dirname(__FILE__), '..', 'mock_templates'))
  config.add(:source_path, :default => 'src')
  config.add(:external_library_path, :default => 'lib')
  config.add(:doc_sources, :default => 'src/')
  config.add(:output_dir, :default => File.join('spec', 'stub'))
end

def mock_config
  MockConfig.instance
end