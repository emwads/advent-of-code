def print_fabric(fabric)
  input = invert_fabric(fabric)
  input.each do |i|
    p i
  end
end

def invert_fabric(fabric)
  max_x = fabric.length
  max_y = fabric.first.length

  inverted = Array.new(max_y) { Array.new(max_x) }

  max_x.times do |i|
    max_y.times do |j|
      inverted[j][i] = fabric[i][j]
    end
  end

  inverted
end



file = File.readlines('input.txt').map { |l| l.chomp }




claims = file.map do |line|
  chunk = line.split('@').last.delete(' ')
  coords = chunk.split(':').first.split(',')
  size = chunk.split(':').last.split('x')

  [[coords.first.to_i, coords.last.to_i], [size.first.to_i, size.last.to_i]]
end


fabric = Array.new(1000) { Array.new(1000, 0) }
# fabric = Array.new(8) { Array.new(8, 0) }

claims.each do |claim|
  coords = claim.first
  size = claim.last

  size.first.times do |i|
    size.last.times do |j|
      fabric[i + coords.first][j + coords.last] += 1
    end
  end
end

# print_fabric(fabric)

# puts "result: #{fabric.flatten.select {|n| n > 1}.count}"

claims.each_with_index do |claim, idx|
  coords = claim.first
  size = claim.last
  has_overlap = false

  size.first.times do |i|
    size.last.times do |j|
      has_overlap = true if fabric[i + coords.first][j + coords.last] > 1
    end
  end

  if has_overlap == false
    puts idx + 1
  end
end
