namespace :db do
  task :reset => :environment do
    puts "Stopping db..."
    Rake::Task['neo4j:stop'].invoke

    puts "Removing db..."
    `rm -rf db/neo4j/development/data/graph.db/`
    `rm *.csv`

    puts "Restarting db..."
    Rake::Task['neo4j:start'].invoke

    `ruby seed.rb`
  end
end