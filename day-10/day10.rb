class Day10
  attr_reader :positions, :velocities, :x_max, :x_min, :y_min, :y_max

  def initialize(filename)
    generate_pos_vel_arrays!(filename)
    calculate_ranges
  end

  def generate_pos_vel_arrays!(filename)
    @velocities = []
    @positions = []

    File.open(filename, "r") do |f|
      f.each_line do |line|
        match_data = /position=<(.*)> velocity=<(.*)>/.match(line)
        @positions << str_to_arr(match_data[1])
        @velocities << str_to_arr(match_data[2])
      end
    end
  end

  def move_n_steps(n)
    @positions = @positions.map.with_index do |old_pos, i|
      [old_pos.first + (n * velocities[i].first), old_pos.last + (n * velocities[i].last)]
    end
    nil
  end

  def str_to_arr(str)
    str.split.map(&:to_i)
  end

  def pos_to_matrix
    mat = Array.new(@y_max - @y_min + 1) { Array.new(@x_max - @x_min + 1) { '.' } }
    @positions.each do |pos|
      mat[pos.last - @y_min][pos.first - @x_min] = '#'
    end

    mat
  end

  def render_stars
    calculate_ranges
    pos_to_matrix.each do |arr|
      arr.each do |el|
        print el
      end
      print "\n"
    end
    nil
  end

  def calculate_ranges
    x_vals = positions.map(&:first)
    y_vals = positions.map(&:last)
    @x_max = x_vals.max
    @x_min = x_vals.min
    @y_max = y_vals.max
    @y_min = y_vals.min

    @x_max - @x_min + @y_max - @y_min
  end

  def move_till_minimum(start_steps, max_steps)
    move_n_steps(start_steps)
    min_size = calculate_ranges
    move_n_steps(1)
    i = 0

    while calculate_ranges < min_size && i < max_steps
      min_size = calculate_ranges
      move_n_steps(1)
      i += 1
    end

    i - 1
  end

  def render_range(start_steps, num_steps)
    i = start_steps
    move_n_steps(start_steps)
    render_stars

    while i < start_steps + num_steps
      move_n_steps(1)
      render_stars
      print i
      sleep(1)
      system "clear" # or cls for osx
      i += 1
    end
  end
end

# day =  Day10.new('./day-10/test.txt')
