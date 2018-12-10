
def react?(char1, char2)
  return true if (char1.ord - char2.ord).abs == 32
end

def polymer_reaction(str)
  has_reaction = true

  while has_reaction == true
    has_reaction = false

    i = 0
    while i < str.length - 1
      if react?(str[i], str[i+1])
        str.slice!(i, 2)
        has_reaction = true
      else
        i += 1
      end
    end
  end

  str.length
end


# {letter => shortes length pos treactino}
def letter_shortest_hash(str)
  letters = str.downcase.split('').uniq

  result = {}
  letters.each do |letter|
    p letter
    temp_str = str.delete(letter).delete((letter.ord - 32).chr)
    result[letter] = polymer_reaction(temp_str)
    p result[letter]
  end

  result
end


# string = File.readlines('test.txt').first.chomp
string = File.readlines('input.txt').first.chomp

# p polymer_reaction(string)
hash = letter_shortest_hash(string)
shortest = hash.min_by {|letter, length| length}
p shortest
