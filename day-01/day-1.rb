

def first_repeat(nums)
  sum = 0
  sum_map = Hash.new(false)
  sum_map[0] = true

  while true
    nums.each do |num|
      sum += num
      return sum if sum_map[sum]
      sum_map[sum] = true
    end
  end

end



input = [+1, -1]
expected = 0
puts "\n\n#{input} : #{expected} \nresult: #{first_repeat(input)} "

input = [+3, +3, +4, -2, -4]
expected = 10
puts "\n\n#{input} : #{expected} \nresult: #{first_repeat(input)} "

input = [-6, +3, +8, +5, -6]
expected = 5
puts "\n\n#{input} : #{expected} \nresult: #{first_repeat(input)} "

input = [+7, +7, -2, -7, -4]
expected = 14
puts "\n\n#{input} : #{expected} \nresult: #{first_repeat(input)} "


input = File.readlines('day-1-input.txt').map { |l| l.chomp.to_i }
puts "\n\n#{input} \nresult: #{first_repeat(input)} "
