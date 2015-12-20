# generate csv file
File.open('source.csv', 'w') do |file|
  content = []
  user_ids = (1..200).to_a.shuffle

  100.times do
    user_a_id, user_b_id = user_ids.pop(2)
    content << "#{user_a_id},#{user_b_id}"

    odd = rand(2)

    content << "#{user_b_id},#{user_a_id}" if odd == 1
  end

  content = content.shuffle.join("\n")

  file.write(content)
end