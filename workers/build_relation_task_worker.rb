module Workers
  class BuildRelationTaskWorker
    include Sidekiq::Worker

    BATCH_SIZE = 1000

    sidekiq_options retry: true

    def perform(file_name)
      file = File.open(file_name)
      error_log_file_name = "error.csv"

      batch = []

      file.each_with_index do |line, i|
        batch << line
        if i % 1000 == 0
          BuildRelationWorker.perform_async(batch, error_log_file_name)
          batch = []
        end
      end
    end
  end
end