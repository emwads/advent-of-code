class Day9b
  attr_accessor :num_players, :last_marble, :marbles, :player_scores, :first_node, :current_player, :marble_to_play, :current_marble

  def initialize(num_players, last_marble)
    @last_marble = last_marble
    @num_players = num_players

    @current_player = 0
    @marble_to_play = 0
    @first_node = Node.new(marble_to_play)
    @current_marble = first_node

    Node.link_node(current_marble, current_marble)

    @player_scores = Hash.new(0)
    @total_marbles = 1
  end

  def play!
    last_marble.times do |_|
      increment_turn
    end
    player_scores.values.max
  end

  def increment_turn
    @marble_to_play += 1
    increment_player
    if marble_to_play % 23 == 0
      play_twenty_third_marble
    else
      place_marble
    end
    print '.' if marble_to_play % 1000 == 0
    @current_marble
  end

  def place_marble
    left = @current_marble.right
    right = left.right
    marble_to_insert = Node.new(marble_to_play)
    Node.link_node(left, marble_to_insert)
    Node.link_node(marble_to_insert, right)

    @current_marble = marble_to_insert
  end

  def increment_player
    @current_player = (current_player + 1) % num_players
  end

  def play_twenty_third_marble
    marble_to_remove = Node.hop_n_steps(current_marble, -7)
    @current_marble = Node.remove_node(marble_to_remove)

    player_scores[current_player] += (marble_to_play + marble_to_remove.value)
  end

  def normalize_marble_idx(idx)
    num_marbles = marbles.length
    (idx + num_marbles) % num_marbles
  end

  # ll. wow. that speed.
  class Node
    attr_accessor :value, :left, :right

    def self.link_node(left, right)
      left.right = right
      right.left = left
    end

    # returns node to the right after removal
    def self.remove_node(node)
      left = node.left
      right = node.right
      link_node(left, right)
      node.left = nil
      node.right = nil
      right
    end

    def initialize(val)
      @value = val
    end

    def self.hop_n_steps(node, steps)
      direction = steps.positive? ? :right : :left

      steps.abs.times do |i|
        node = node.send(direction)
      end
      node
    end

    def print_nodes
      start_value = self.value
      node = self
      values = [node.value]
      node = node.right

      until node.value == start_value
        values << node.value
        node = node.right
      end

      p values
    end
  end
end



# 10 players; last marble is worth 1618 points: high score is 8317
# 13 players; last marble is worth 7999 points: high score is 146373
# 17 players; last marble is worth 1104 points: high score is 2764
# 21 players; last marble is worth 6111 points: high score is 54718
# 30 players; last marble is worth 5807 points: high score is 37305

# nope
# t_start = Time.now
# p Day9.new(418, 7076900).play!
# t_end = Time.now
# p t_end - t_start
