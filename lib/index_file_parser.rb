class IndexFileParser

  @@index_file = './indexes/index'

  def self.index_file
    @@index_file
  end

  def self.find_index(word)
    pattern = '<' + word + '>'
    File.open(self.index_file).grep(/#{pattern}/)[0]
  end

  def self.process_file(file)
    found_words = self.parse_file(file)

    if !found_words.empty?
      self.store_indexes(found_words, file)
    end
  end

  #protected

  def self.parse_file(file)
    found_words = []

    if !File.exist?(file)
      return found_words
    end

    File.open(file, 'r') do |infile|
      while (line = infile.gets)
        found_words += line.gsub(/[^a-z ]/i, '').downcase.split(" ")
      end
    end

    return found_words.uniq
  end

  def self.store_indexes(words, file)
    words.each do |word|
      self.add_index(word, file)
    end
  end

  def self.add_index(word, file_name)
    index_raw = self.find_index(word)

    if index_raw.nil?
      puts "adding new index for `#{word}`"
      add_index_file = File.open(self.index_file, 'a+')
      add_index_file.puts("<#{word}>:[#{file_name}]")
    else
      puts "updating index for `#{word}`"
      files = self.append_new_file_to_index(index_raw, file_name)
      file_content = File.read(self.index_file)
      new_content = file_content.gsub("#{index_raw}", "<#{word}>:[#{files}]\n")
      File.open(self.index_file, "w") {|file| file.puts new_content }
    end
  end

  def self.append_new_file_to_index(index, file)
    files = index.match('\[.*\]')[0].gsub('[', '').gsub(']', '').split(',')

    if !files.include? file
      files.push(file)
    end

    return files.join(',')
  end

end