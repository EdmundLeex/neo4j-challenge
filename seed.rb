require 'rubygems'
require 'bundler'

Bundler.require

require_all 'models', 'controllers'

Neo4j::Session.open(:server_db)
Neo4j::Transaction.run do
  100.times do
    begin
      User.create(username: Faker::Internet.user_name)
      print "."
    rescue Neo4j::Server::CypherResponse::ConstraintViolationError
      retry
    end
  end
end

puts "\n"

# generate csv file

File.open('source.csv', 'w') do |file|
  content = []
  user_ids = User.all.map(&:uuid).shuffle

  user_ids.each_with_index do |uid_a, i|
    user_ids.each_with_index do |uid_b, j|
      next if i == j
      odd = rand(2)
      content << "#{uid_a},#{uid_b}" if odd == 1
    end
  end

  content = content.shuffle.join("\n")

  file.write(content)
end

puts "Database seeded"