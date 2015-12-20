require 'byebug'
require_relative '../models/concerns/file_sorter'

describe FileSorter do
  describe "#split_file" do
    let (:file_sorter) { FileSorter.new('source.csv') }
    destination = 'chunks'

    before do
      file_sorter.mkdir(destination)
      file_sorter.split(destination, 10)
    end

    after { file_sorter.rm_dir(destination) }

    it "splits a large file into smaller files" do

      num_of_files = `ls #{destination}`.count("\n")
      num_of_chunks = file_sorter.file.count.divmod(10)
      num_of_chunks = if num_of_chunks[1].zero?
        num_of_chunks[0]
      else
        num_of_chunks[0] + 1
      end

      expect(num_of_files).to eq num_of_chunks
    end

    it "sort a collection of files" do
      file_names = Dir["#{destination}/*"]
      file_sorter.sort_files(file_names, "./")
      target_sorted_file = File.readlines("source.csv").map(&:chomp).sort
      sorted_file = File.readlines("sorted.csv").map(&:chomp)

      expect(sorted_file).to eq target_sorted_file

      system("rm sorted.csv")
    end
  end
end