class Day12
  attr_accessor :plants, :generation, :mapping, :history, :differences

  def initialize(filename)
    input = File.readlines(filename)
    plants_array = convert_to_true_false_array(input.first)
    @plants = Hash.new
    plants_array.each_with_index { |plant, ind| @plants[ind] = plant}
    @mapping = generate_mapping(input)
    @min_index = 0
    @max_index = plants_array.length - 1
    @generation = 1
    @history = { 1 => sum_plants }
    @differences = { }
  end

  def convert_to_true_false_array(input)
    plants = []
    initial = input.each_char do |c|
      plants << true if c == '#'
      plants << false if c == '.'
    end
    plants
  end

  def generate_mapping(input)
    map = Hash.new(false)
    input = input[2..-1]
    input.each do |line|
      state, result = line.chomp.split(' => ')
      state = convert_to_true_false_array(state)
      result = convert_to_true_false_array(result).first
      map[state] = result
    end

    map.select{ |k, v| v }
  end

  def increment_generation
    next_gen_plants = Hash.new

    (@min_index - 2 .. @max_index + 2).each do |ind|
      surrounding = surrounding_plants(ind)
      new_state = @mapping[surrounding]

      next_gen_plants[ind] = new_state
    end

    @min_index, @max_index = find_min_max_ind(next_gen_plants)

    @plants = next_gen_plants
  end

  def find_min_max_ind(plants)
    min = max = nil
    plants.each do |ind, plant|
      min = ind if plant && (!min || (ind < min))
      max = ind if plant && (!max || (ind > max))
    end

    [min, max]
  end

  def surrounding_plants(index)
    [
      @plants[index - 2] || false,
      @plants[index -1] || false,
      @plants[index] || false,
      @plants[index + 1] || false,
      @plants[index + 2] || false
    ]
  end

  def to_s
    print "\n"
    @plants
      .sort_by{ |k,v| k }
      .map{ |pair| pair.last ? '#' : '.' }
      .each{ |el| print el}
  end

  def sum_plants
    @plants.sum { |ind, plant| plant ? ind : 0 }
  end

  def increment_generations(n)
    n.times do |i|
      increment_generation
      @generation += 1
      @history[@generation] = sum_plants
      @differences[@generation] = @history[@generation] - @history[@generation - 1]
    end
    sum_plants
  end
end


# d = Day12.new('./day-12/test.txt')
