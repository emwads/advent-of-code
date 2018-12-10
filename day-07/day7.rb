class Day7
  attr_accessor :order_array, :node_hash, :requirements_hash, :result

  def initialize(filename)
    @order_array = File.readlines(filename).map { |l| format_input(l) }
    @node_hash = Hash.new
    @requirements_hash = Hash.new
    @result = []

    make_hashes # :(
  end

  def format_input(line)
    line = line.chomp
    match_data = /Step ([a-zA-Z]) must be finished before step ([a-zA-Z]) can begin/.match(line)
    [match_data[1], match_data[2]]
  end

  def call
    available_steps = find_parents

    loop do
      break if available_steps.empty?
      new_node = available_steps.sort!.shift
      result << new_node
      children = node_hash[new_node]
      next if children.nil?
      children.each do |child_node|
        available_steps << child_node if valid_step?(child_node)
      end
    end

    result
  end

  def valid_step?(node)
    requirements_hash[node].each do |req|
      return false unless result.include?(req)
    end
    true
  end

  def make_hashes #why?
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

  def find_parents
    node_hash.keys - node_hash.values.flatten.uniq
  end

  def num_seconds(node)
    node.ord - 64 + 60
  end
end

p Day7.new('test.txt').call.join('')
p Day7.new('input.txt').call.join('')
