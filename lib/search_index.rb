require './lib/index_file_parser'

class SearchIndex

  def self.find(search_string)
    found_indexes = []
    words_to_find = self.process_search_query(search_string)

    words_to_find.each do |word|
      found_indexes.push(IndexFileParser.find_index(word))
    end

    result = self.search_result(found_indexes)

    if (result.empty?)
      result = 'No files such entry found'
    end

    return result
  end

  def self.search_result(found_data)
    result = []

    found_data.each do |index|
      if !index.nil?
        word  = index.match('<.*>')[0].gsub('<', '`').gsub('>', '`')
        files = index.match('\[.*\]')[0].gsub('[', '').gsub(']', '')
        result.push "#{word} found in file(s): #{files}"
      end
    end

    return result
  end

  def self.process_search_query(string)
    string.downcase.split(" ")
  end

end