# returns array of coords
def format_file(input)
  input.map do |line|
    line.split(',').map(&:to_i)
  end
end

# returns outer bounds : [max_x, max_y, min_x, min_y]
def bounds(coords)
  x_coords = coords.map { |coord| coord.first }
  y_coords = coords.map { |coord| coord.last }

  [x_coords.max, y_coords.max, x_coords.min, y_coords.min]
end

def distance(coord1, coord2)
  (coord1.first - coord2.first).abs + (coord1.last - coord2.last).abs
end

# returns the index of the closest coordinate, or nil if tied
def closest_coord(coord_arr, coords)
  distances = {}
  coords.each do |coord|
    distances[coord] = distance(coord, coord_arr)
  end

  min_dist = distances.values.min
  closest = distances.select{ |c, v| v == min_dist }

  return nil if closest.length > 1
  coords.index(closest.keys.first)
end

# a hash giving the index of then closest coordinate or nil if tied for each coords within the bounds
#  {[1,1] => 0}
def closest_hash(coords)
  max_x, max_y, min_x, min_y = bounds(coords)
  h = {}

  (min_x..max_x).each do |x|
    (min_y..max_y).each do |y|
      coord_arr = [x, y]
      h[coord_arr] = closest_coord(coord_arr, coords)
    end
  end

  h
end

# removes all edge nodes from closest Hash
def non_infinite_hash(coords)
  h = closest_hash(coords)
  result = h.dup
  max_x, max_y, min_x, min_y = bounds(coords)

  h.each do |coord, val|
    if  coord.first == min_x || coord.first == max_x || coord.last == min_y || coord.last == max_y
      result.reject! { |_, v| v == val }
    end
  end

  result
end

def area_by_coord(coords)
  coords = non_infinite_hash(coords)

  counter = Hash.new(0)
  coords.each { |_, v| counter[v] += 1 }
  counter
end

def max_area(coords)
  area_by_coord(coords).max_by { |c, a| a }
end

def total_distance(coord_arr, coords)
  coords.reduce(0) do |sum, coord|
    sum += distance(coord, coord_arr)
  end
end

# hash within boundary of total distance from all points
def total_distance_hash(coords)
  max_x, max_y, min_x, min_y = bounds(coords)
  h = {}

  (min_x..max_x).each do |x|
    (min_y..max_y).each do |y|
      coord_arr = [x, y]
      h[coord_arr] = total_distance(coord_arr, coords)
    end
  end

  h
end


def hash_less_than(dist, coords)
  total_distance_hash(coords).reject { |k, v| v >= dist }
end


file = File.readlines('input.txt').map { |l| l.chomp }
# file = File.readlines('test.txt').map { |l| l.chomp }
coords = format_file(file)
p hash_less_than(10000, coords)
p hash_less_than(10000, coords).count
