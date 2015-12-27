module Workers
  class BuildRelationTaskWorker
    include Sidekiq::Worker

    BATCH_SIZE = 1000

    sidekiq_options retry: true

    def perform(file_name)
      file = File.open(file_name)

      batch = []

      file.each_with_index do |line, i|
        batch << line
        if i % 1000 == 0
          # BuildRelationWorker.perform_async(batch, error_log_file_name)
          build_rel(batch)
          batch = []
        end
      end
    end

    private

    def build_rel(batch)
      error_log_file_name = "error.csv"
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

    def is_valid_data?(data)
      regex = /^[a-z|\d]{8}-([a-z|\d]{4}-){3}[a-z|\d]{12},[a-z|\d]{8}-([a-z|\d]{4}-){3}[a-z|\d]{12}$/i
      !!(data =~ regex)
    end
  end
end