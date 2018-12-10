


input = ['abcdef',
'bababc',
'abbcde',
'abcccd',
'aabcdd',
'abcdee',
'ababab']


def checksum(strs)
  str_counter = {
    2 => 0,
    3 => 0
  }
  strs.each do |str|
    letter_counter = Hash.new(0)

    str.each_char do |l|
      letter_counter[l] += 1
    end

    str_counter[2] += 1 if letter_counter.find { |k, v| v == 2 }
    str_counter[3] += 1 if letter_counter.find { |k, v| v == 3 }
  end

  str_counter[2] * str_counter[3]
end

#
#
# input = File.readlines('input.txt').map { |l| l.chomp }
# puts  checksum(input)


def find_boxes(codes)
  i = 0
  code_length = codes.first.length

  while codes.length > 1
    word = codes.shift
    result = []

    codes.each do |code|
      letters = matching_letters(word, code)
      return letters if letters.length == code_length - 1
    end
  end
end

def matching_letters(word1, word2)
  matching = ''
  word1.length.times do |i|
    matching += word1[i] if word1[i] == word2[i]
  end

  matching
end


input = [
  'abcde',
  'fghij',
  'klmno',
  'pqrst',
  'fguij',
  'axcye',
  'wvxyz',
]

# puts "\n\n#{input} : fgij  \nresult: #{find_boxes(input)} "


input = File.readlines('input.txt').map { |l| l.chomp }
puts "\n\n#{input}\nresult: #{find_boxes(input)} "
