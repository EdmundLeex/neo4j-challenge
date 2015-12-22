require 'byebug'
class UserRelationBuilder
  def initialize
    @tasks = Queue.new
  end

  def build_from_file(file_name)
    sort_file(file_name)

    tb = TaskBuilder.new('sorted.csv', @tasks)
    tb.build_task_queue

    until @tasks.empty?
      task = @tasks.pop

      # worker = Worker.new(task)
      # worker.build
    end
  end

  def sort_file(file_name)
    system('touch sorted.csv')
    system("gsort --parallel=2 -o sorted.csv #{file_name}")
  end
end

class TaskBuilder
  # include Celluloid

  attr_reader :tasks

  def initialize(file_name, tasks)
    @file = File.open(file_name)
    @tasks = tasks
  end

  def build_task_queue
    task = []
    current = nil

    @file.each_line do |line|
      current ||= line.split(',')[0]
      if line.split(',')[0] == current
        task << line
      else
        @tasks << task
        task = [line]
        current = line.split(',')[0]
      end
    end

    @tasks = nil if @file.eof?
  end
end

class Worker
  include Celluloid

  def initialize(rows)
    @rows = rows
  end

  def build
    Neo4j::Session.open(:server_db)

    @rows.each do |row|
      uid_a, uid_b = row.chomp.split(",")
      user_a = User.find(uid_a)
      user_b = User.find(uid_b)

      user_a.followers << user_b
    end
  end
end




