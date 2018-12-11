class Day8
  attr_accessor :input, :root_node, :all_nodes

  def initialize(filename)
    @input = File.readlines(filename).first.chomp.split(' ').map(&:to_i)

    # root_metadata_entries = input[1]
    # root_metadata = input[-root_metadata_entries..-1]
    # @root_node = Node.new(nil, root_metadata, 0)
    @all_nodes = []

    generate_tree!
  end

  def generate_tree!
    generate_child!(nil, 0)
    @root_node = all_nodes.first
  end

  def sum_metadata
    all_nodes.reduce(0) do |sum, node|
      sum + node.metadata.sum
    end
  end

  # returns last index of child
  def generate_child!(parent, start_index)
    num_grandchildren = input[start_index]
    child = Node.new(parent, start_index, num_grandchildren)
    parent.children << child if parent
    all_nodes << child

    index = start_index + 2
    num_grandchildren.times do |j|
      index = generate_child!(child, index) + 1
    end

    num_metadata = input[start_index + 1]
    child.metadata = input.slice(index, num_metadata)

    index += child.metadata.length

    child.end_index = index - 1
  end


  # making a tree thing.
  class Node
    attr_accessor :parent, :metadata, :start_index, :num_children, :end_index, :children

    def initialize(parent, start_index, num_children, metadata = [])
      @parent = parent
      @children = []
      @num_children = num_children
      @metadata = metadata
      @start_index = start_index
    end

    def value
      return self.metadata.sum if self.num_children.zero?
      self.metadata.reduce(0) do |sum, idx|
        sum + (self.children[idx - 1]&.value || 0)
      end
    end
  end
end



# day =  Day8.new('./day-08/test.txt').sum_metadata
# p Day8.new('./day-08/input.txt').sum_metadata
