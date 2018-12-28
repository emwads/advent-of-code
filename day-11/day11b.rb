class Day11b
  def initialize(serial_number)
    @serial_number = serial_number
    @individual_power = Hash.new
    @max_power = 0
    @max_power_n = nil
    @max_power_coords = nil
  end

  def call
    populate_individual_power_hash!
    max_power_size
  end

  def calculate_power(x, y)
    rack_id = x + 10
    num = ((rack_id * y) + @serial_number) * (rack_id)
    result = hundreds_place(num) - 5
    binding.pry if result == nil
    result
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

  # calculate the power for each sized grid (1-300) at point x,y
  def calculate_power_at(x,y)
    sum = @individual_power[[x, y]]
    n = 1
    store_max_power(n, [x,y], sum) if sum > @max_power
    @all_power = Hash.new

    while n < (300 - [x, y].max)
      n += 1
      (0..(n-2)).each do |i|

        sum = sum + @individual_power[[i + x, n + y - 1]] + @individual_power[[x + n - 1, y + i]]
      end
      sum += @individual_power[[x + n - 1, y + n -1]]

      store_max_power(n, [x,y], sum) if sum > @max_power
    end
  # rescue => e
  #   binding.pry
  end

  def store_max_power(n, coords, power)
    @max_power = power
    @max_power_coords = coords
    @max_power_n = n
    # print "max_power for #{n} @ #{coords} : #{power}\n"
  end

  def max_power_size
    (1..300).each do |i|
      print '.'
      (1..300).each do |j|
        calculate_power_at(i,j)
      end
    end
    puts "max_power: #{@max_power}"
    puts "max_power_n: #{@max_power_n}"
    puts "max_power_coords: #{@max_power_coords}"
  end
end

# d = Day11b.new(9798)
# d.call
