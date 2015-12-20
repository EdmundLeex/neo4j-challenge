module SystemCommand
  def mkdir(dir)
    system("mkdir #{dir}")
    dir
  end

  def rm_dir(dir)
    system("rm -rf #{dir}")
  end

  def sys_sort_one_file(file_name)
    `sort #{file}`
  end

  def sys_sort(file_names, destination)
    file_names_str = file_names.join(' ')
    system("sort #{file_names_str} >> #{destination}/sorted.csv")
  end

  def sys_split(file_name, destination, line_limit)
    system("split -l #{line_limit} #{file_name} #{destination}/")
  end

  def sys_count(file_name)
    `wc -l #{file_name}`.split(' ')[0].to_i + 1
  end

  private :sys_sort, :sys_sort_one_file, :sys_count
end