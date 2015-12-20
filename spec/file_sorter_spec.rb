require_relative '../models/concerns/file_sorter'

describe FileSorter do
  describe "#split_file" do
    let (:file_sorter) { FileSorter.new('source.csv') }

    it "splits a large file into smaller files" do
      destination = 'chunks'
      file_sorter.mkdir(destination)
      file_sorter.split(destination, 10)

      num_of_files = `ls #{destination}`.count("\n")
      num_of_chunks = file_sorter.file.count.divmod(10)
      num_of_chunks = if num_of_chunks[1].zero?
        num_of_chunks[0]
      else
        num_of_chunks[0] + 1
      end

      expect(num_of_files).to eq num_of_chunks
      file_sorter.rm_dir(destination)
    end
  end
end