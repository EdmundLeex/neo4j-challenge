module Workers
  class LogErrorWorker
    include Sidekiq::Worker

    sidekiq_options retry: true

    def perform(file_name, source_data)
      file = CSV.open(file_name, 'a')
      source_data.each do |row|
        error = row.split("<=error_msg=>")
        file << error
      end

      file.flush
      file.close
    end
  end
end