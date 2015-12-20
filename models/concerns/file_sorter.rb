class FileSorter
  def initialize
    
  end

  private

  def mkdir(dir)
    system("mkdir #{dir}")
    dir
  end

  def rm_dir(dir)
    system("rm -rf #{dir}")
  end

  def split_file(file, destination, line_limit = 2000)
    unless system("split -l #{line_limit} #{file} #{destination}/")
      split_file_alt(file, line_limit, destination)
    end
  end

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

  def sort_file(file)
    sorted_content = `sort #{file}`

    if sorted_content == ""
      sorted_content = File.readlines(file).sort
    end

    File.open(file, 'w') { |f| f.write sorted_content }
  end

  def sort_files(files, destination)
    files_str = files.join(' ')
    unless system("sort #{files_str} >> #{destination}/sorted.csv")
      external_sort(files, destination)
    end
  end

end