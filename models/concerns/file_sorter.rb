require_relative 'system_command'

class FileSorter
  include SystemCommand

  attr_reader :file_name, :file

  def initialize(file_name)
    @file_name = file_name
    @file = File.open(file_name)
    @num_of_lines = sys_count(file_name) || @file.count
  end

  def sort_files(file_names, destination)
    unless sys_sort(file_names, destination)
      external_sort(file_names, destination)
    end
  end

  def split(destination, line_limit = 2000)
    unless sys_split(file_name, destination, line_limit)
      split_file_alt(file_name, line_limit, destination)
    end
  end

  private

  # Use this if OS split command doesn't work
  def split_file_alt(file, line_limit, destination)
    out_file_num = 0

    File.open(file) do |f_in|
      until f.eof?
        File.open("#{destination}/temp_#{out_file_num}", "w") do |f_out|
          line = ""
          until out_file_num % line_limit == 0 || f_in.eof?
            line = f_in.readline
            f_out << line
          end
        end
        out_file_num += 1
      end
    end
  end

  def sort_file(file_name)
    sorted_content = sys_sort_one_file(file_name)

    if sorted_content == ""
      sorted_content = File.readlines(file_name).sort
    end

    File.open(file_name, 'w') { |f| f.write sorted_content }
  end

  def external_sort(file_names, destination, chunk_size)
    files = file_names.map { |fn| PartialFile.new(fn, chunk_size) }
    target_file = File.open("#{destination}/sorted.csv", "a")

    until files.all?(&:eof?)
      smallest = nil
      idx = nil

      files.each_with_index do |file, i|
        if file.current_chunk.nil? || file.pointer == chunk_size
          file.grab_next_chunk
        end

        line = file.current_chunk[file.pointer]
        smallest ||= line

        if smallest > line
          smallest = line
          idx = i
        end
      end

      files[idx].next_line
      target_file.write(smallest)
    end
  end

  class PartialFile
    include SystemCommand

    attr_reader :pointer, :current_chunk

    def initialize(file_name, chunk_size = 5000)
      @enum          = File.open(file_name).each_line
      @chunk_size    = chunk_size
      @current_chunk = nil
      @pointer       = 0
      @eof           = false
    end

    def grab_next_chunk
      @current_chunk = enum.take(chunk_size).tap do |chunk|
        @eof = true if chunk.empty?
        @pointer = 0
      end
    end

    def next_line
      @pointer += 1
    end

    def eof?
      @eof
    end

    private
    attr_reader :enum, :chunk_size, :file
  end
end