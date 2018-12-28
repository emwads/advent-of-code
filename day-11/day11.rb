class Day11
  def initialize(serial_number)
    @serial_number = serial_number
    @individual_power = Hash.new
    @size_power = Hash.new
  end

  def call
    populate_individual_power_hash!
    max_power_size
  end

  def calculate_power(x, y)
    rack_id = x + 10
    num = ((rack_id * y) + @serial_number) * (rack_id)
    hundreds_place(num) - 5
  end

  def hundreds_place(num)
    (num / 100) % 10
  end

  def populate_individual_power_hash!
    (1..300).each do |x|
      (1..300).each do |y|
        @individual_power[[x,y]] = calculate_power(x,y)
      end
    end
  end

  def calculate_power_grid(x,y,n)
    grid = []
    n.times do |i|
      n.times do |j|
        grid << @individual_power[[x + i, y + j]]
      end
    end

    grid.sum
  end

  def max_power_for_size(n)
    max = 0
    coords = nil
    (1..(301 - n)).each do |i|
      (1..(301-n)).each do |j|
        grid = calculate_power_grid(i, j, n)
        if grid > max
          max = grid
          coords = [i, j]
        end
      end
    end
    [coords, max]
  end

  def max_power_size
    (1..300).each do |i|
      @size_power[i] =max_power_for_size(i)
      p "#{i}: #{@size_power[i]}"
    end
  end
end
