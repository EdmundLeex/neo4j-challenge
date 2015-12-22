require 'rspec/core/rake_task'
require 'neo4j/rake_tasks'

RSpec::Core::RakeTask.new(:spec)

task :environment do
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__),'lib'))

  Dir[File.join(File.dirname(__FILE__), "model" , "**/*.rb")].each do |f|
    require f
  end
end

task :default => [:environment, :spec] do
  
end

Rake.add_rakelib('lib/tasks')