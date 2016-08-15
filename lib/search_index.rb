require './lib/index_file_parser'

class SearchIndex

  def self.find(search_string)
    result = []
    is_and_expression = self.is_special_and_expression_exists(search_string)

    # Do strict search with AND expression
    if is_and_expression
      found_files = self.do_search_with_and(search_string)
      if !found_files.empty?
        result = self.prepare_strict_search_output(found_files)
      end
    # Do regular search
    else
      found_indexes = self.do_search(search_string)
      result = self.prepare_search_output(found_indexes)
    end

    if (result.empty?)
      result = 'No files with such entry found'
    end

    return result
  end

  #protected

  # Prepare found data format for outputting to user
  def self.prepare_search_output(found_data)
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

  # Prepare found data format for outputting to user
  def self.prepare_strict_search_output(files)
    return "All searched words found in: #{files}"
  end

  # Do regular search
  def self.do_search(query)
    found_indexes = []
    words_to_find = self.prepare_search_query(query)

    words_to_find.each do |word|
      found_indexes.push(IndexFileParser.find_index(word))
    end

    return found_indexes
  end

  # Do search only files where all words form search query present
  def self.do_search_with_and(query)
    found_indexes = {}

    words_to_find = query.split('AND')
    words_to_find.each do |word|
      word = word.downcase.strip! || word.downcase
      index = IndexFileParser.find_index(word)
      found_indexes[word] = []
      if !index.nil?
        found_indexes[word] = index.match('\[.*\]')[0].gsub('[', '').gsub(']', '').split(',')
      end
    end

    all_found_files = []
    found_indexes.each do |key, val|
      all_found_files += val
    end

    return all_found_files.find_all { |e| all_found_files.count(e) > 1 }.uniq
  end

  # Convert search string to lowercase format
  def self.prepare_search_query(string)
    string.downcase.split(" ")
  end

  # Check if AND special word is used
  def self.is_special_and_expression_exists(query_string)
    query_string.include? 'AND'
  end

end