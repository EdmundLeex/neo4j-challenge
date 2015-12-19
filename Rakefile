require 'rspec/core/rake_task'
require 'neo4j-core'

load 'neo4j/tasks/neo4j_server.rake'

RSpec::Core::RakeTask.new(:spec)

task :environment do
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__),'lib'))

  Dir[File.join(File.dirname(__FILE__), "lib" , "**/*.rb")].each do |f|
    require f
  end
end

task :default => [:environment, :spec] do
  
end

