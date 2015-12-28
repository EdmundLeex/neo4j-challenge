module Workers
  class BuildRelationWorker
    include Sidekiq::Worker

    sidekiq_options retry: true

    def perform(batch, error_log_file_name)
      Neo4j::Session.open(:server_db)

      error_rows = []
      Neo4j::Transaction.run do
        batch.each do |row|
          # check if matches neo4j uuid pattern
          unless is_valid_data?(row)
            error_rows << "#{row.chomp}<=error_msg=>InvalidId"
            next
          end

          uid_a, uid_b = row.chomp.split(",")

          begin
            user_a = User.find(uid_a)
            user_b = User.find(uid_b)
          rescue Neo4j::RecordNotFound
            error_rows << "#{row.chomp}<=error_msg=>RecordNotFound"
            next
          end

          if user_a.followers.where(uuid: user_b.uuid).empty?
            user_a.followers << user_b
          else
            error_rows << "#{row.chomp}<=error_msg=>DuplicatedEntry"
          end
        end
        LogErrorWorker.perform_async(error_log_file_name, error_rows)
        error_rows = []
      end
    end

    private

    def is_valid_data?(data)
      regex = /^[a-z|\d]{8}-([a-z|\d]{4}-){3}[a-z|\d]{12},[a-z|\d]{8}-([a-z|\d]{4}-){3}[a-z|\d]{12}$/i
      !!(data =~ regex)
    end
  end
end