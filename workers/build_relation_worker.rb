module Workers
  class BuildRelationWorker
    include Sidekiq::Worker

    sidekiq_options retry: true

    def perform(batch)
      Neo4j::Session.open(:server_db)

      Neo4j::Transaction.run do
        batch.each do |row|
          uid_a, uid_b = row.chomp.split(",")

          user_a = User.find(uid_a)
          user_b = User.find(uid_b)

          user_a.followers << user_b
        end
      end
    end
  end
end