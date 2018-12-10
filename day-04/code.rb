#
# def generate_sleep_times(log)
#
#   sleep_times = Hash.new([])
#   current_guard =  /Guard #(\d+) begins/.match(log.first)[1]
#   asleep = nil
#
#   log[1..-1].each do |line|
#     new_guard = /Guard #(\d+) begins/.match(line)
#     minute = /\[\d+-\d+-\d+ \d+:(\d+)\]/.match(line)[1].to_i
#     if new_guard
#       if asleep
#         sleep_times[current_guard] = sleep_times[current_guard] << [asleep, 60]
#       end
#       current_guard = new_guard[1]
#     elsif /falls asleep/.match(line)
#       asleep = minute
#     elsif /wakes up/.match(line)
#       sleep_times[current_guard] = sleep_times[current_guard] << [asleep, minute]
#       asleep = nil
#     end
#   end
#
#   sleep_times
# end

def generate_sleep_times(log)

  sleep_times = Array.new(60) { [] }
  current_guard =  /Guard #(\d+) begins/.match(log.first)[1]
  asleep = nil
  awake = nil

  log[1..-1].each do |line|
    new_guard = /Guard #(\d+) begins/.match(line)
    minute = /\[\d+-\d+-\d+ \d+:(\d+)\]/.match(line)[1].to_i
    if new_guard
      # if asleep
      #   sleep_times[current_guard] = sleep_times[current_guard] << [asleep, 60]
      # end
      current_guard = new_guard[1]
    elsif /falls asleep/.match(line)
      asleep = minute
    elsif /wakes up/.match(line)
      awake = minute

      (asleep...awake).each do |min|
        sleep_times[min] = sleep_times[min] << current_guard
      end
      asleep = nil
      awake = nil
    end
  end

  sleep_times
end

# {guard => minutes}
def minutes_per_guard(sleep_times)
  result = Hash.new(0)

  sleep_times.flatten.each do |guard|
    result[guard] += 1
  end

  result
end

# guard with the most total sleep
def max_minutes_guard(sleep_times)
  minutes_guard = minutes_per_guard(sleep_times)
  guard, _ = minutes_guard.max_by{ |guard, min| min}
  guard
end

#
def most_asleep_minutes_for(sleep_times, cool_guard)
  times_asleep = {}
  sleep_times.each_with_index do |guards, min|
    total_time = guards.select {|guard| guard == cool_guard}.count
    times_asleep[min] = total_time
  end

  times_asleep
end

# time, and number of times that the guard was most likely asleep
def most_likely_asleep(sleep_times, guard)
  minutes_hash = most_asleep_minutes_for(sleep_times, guard)
  time, num_times = minutes_hash.max_by { |min, times| times}
end

# {guard_id => [minute, times]}
def guard_max_minute_maker(sleep_times)
  guards = minutes_per_guard(sleep_times).keys
  result = {}
  guards.each do |guard|
    result[guard] = most_likely_asleep(sleep_times, guard)
  end

  result
end

def guard_most_likely_asleep(sleep_times)
  guards_max_minute = guard_max_minute_maker(sleep_times)
  guards_max_minute.max_by { |guard, min_times| min_times.last }
end

file = File.readlines('input.txt').map { |l| l.chomp }.sort
# file = File.readlines('test.txt').map { |l| l.chomp }.sort
sleep_times =  generate_sleep_times(file)
#
# guard = max_minutes_guard(sleep_times)
# p guard
#
#
# time =  most_likely_asleep(sleep_times, guard)
# p time

# all_guards_times =  guard_max_minute_maker(sleep_times)
# p all_guards_times

result = guard_most_likely_asleep(sleep_times)
p result
