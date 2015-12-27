require_relative './config/environment'

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
      odd = rand(7)
      if odd < 4
        content << "#{uid_a},#{uid_b}"
      elsif odd == 5
        content << Faker::Bitcoin.address
      elsif odd == 6
        2.times { content << "#{uid_a},#{uid_b}" }
      # else
      #   uid_a.gsub!(/\d/, "9")
      #   uid_b.gsub!(/\d/, "2")
      #   content << "#{uid_a},#{uid_b}"
      end
    end
  end

  content = content.shuffle.join("\n")

  file.write(content)
end

puts "Database seeded"