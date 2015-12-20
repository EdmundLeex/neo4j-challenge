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
      external_sort(files, destination)
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
end