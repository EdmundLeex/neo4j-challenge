require 'rubygems'
require 'bundler'

Bundler.require

require_all 'workers', 'models', 'controllers', 'lib'

puts "Sidekiq error log can be found at '#{Dir.pwd}/sidekiq_error_log.csv'"

Sidekiq.configure_server do |config|
  config.error_handlers << Proc.new do |ex,ctx_hash|
    file = CSV.open('sidekiq_error_log.csv', 'a')
    file << [ex, ctx_hash]

    file.flush
    file.close
  end
end

Neo4j::Session.open(:server_db)