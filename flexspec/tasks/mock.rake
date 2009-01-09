require File.dirname(__FILE__) + '/config'

namespace :mock do
  task :build do
    system("asdoc -source-path #{mock_config.source_path} -doc-sources #{mock_config.doc_sources} -external-library-path+=#{mock_config.external_library_path} -templates-path #{mock_config.templates_path}")
  end
end

class MockConfig < Rake::Config
end

MockConfig.configure do |config|
  config.add(:templates_path, :default => File.join(File.dirname(__FILE__), '..', 'mock_templates'))
  config.add(:source_path, :default => 'src')
  config.add(:external_library_path, :default => 'lib')
  config.add(:doc_sources, :default => 'src/')
end

def mock_config
  MockConfig.instance
end