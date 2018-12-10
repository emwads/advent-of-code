require 'pry'
class Day7b
  attr_accessor :order_array, :node_hash, :requirements_hash, :finished_jobs, :work_schedule, :time, :available_steps

  def initialize(filename)
    @order_array = File.readlines(filename).map { |l| format_input(l) }
    @node_hash = Hash.new
    @requirements_hash = Hash.new
    @finished_jobs = []
    # assume jobs are in a [work node, time finished] format
    @work_schedule = {1 => nil, 2 => nil, 3 => nil, 4 => nil, 5 => nil}
    # @work_schedule = {1 => nil, 2 => nil}
    @time = 0
    @available_steps = []

    make_hashes # :(
  end

  def format_input(line)
    line = line.chomp
    match_data = /Step ([a-zA-Z]) must be finished before step ([a-zA-Z]) can begin/.match(line)
    [match_data[1], match_data[2]]
  end

  def call

    @available_steps = find_parents

    while true
      p "finished_jobs : #{@finished_jobs}"
      p "available_steps : #{@available_steps}"
      finish_jobs!
      break if finished_jobs.length == total_steps
      add_jobs!
      @time = @time + 1
      p @time
    end

    @time
  end

  def finish_jobs!
    work_schedule.each do |k,v|
      if v && v.last == time
        finished_jobs << v.first
        work_schedule[k] = nil
        enqueue_some_more!(v.first)
      end
    end
  end

  def enqueue_some_more!(parent)
    children = node_hash[parent]
    return if children.nil?

    children.each do |child_node|
      available_steps << child_node if valid_step?(child_node)
    end
  end

  def add_jobs!
    work_schedule.each do |worker, job|
      if job.nil? && !available_steps.empty?
        new_node = available_steps.sort!.shift
        work_schedule[worker] = [new_node, time + num_seconds(new_node)]
      end
    end
  end


  def valid_step?(node)
    requirements_hash[node].each do |req|
      return false unless finished_jobs.include?(req)
    end
    true
  end

  def make_hashes
    order_array.each do |edge|
      if node_hash[edge.first]
        node_hash[edge.first] = node_hash[edge.first] << edge.last
      else
        node_hash[edge.first] = [edge.last]
      end

      if requirements_hash[edge.last]
        requirements_hash[edge.last] = requirements_hash[edge.last] << edge.first
      else
        requirements_hash[edge.last] = [edge.first]
      end
    end
  end

  def total_steps
    @total_steps ||= order_array.flatten.uniq.count
  end

  def find_parents
    node_hash.keys - node_hash.values.flatten.uniq
  end

  def num_seconds(node)
    node.ord - 64 + 60
  end
end

p Day7b.new('input.txt').call
