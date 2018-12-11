class Day9
  attr_accessor :num_players, :last_marble, :marbles, :player_scores, :current_player, :marble_to_play, :current_marble_idx

  def initialize(num_players, last_marble)
    @last_marble = last_marble
    @num_players = num_players

    @current_player = 0
    @marble_to_play = 0
    @current_marble_idx = 0

    @player_scores = Hash.new(0)
    @marbles = [0]
  end

  def play!
    last_marble.times do |i|
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
  end

  def place_marble
    placement_index = normalize_marble_idx(current_marble_idx + 2)
    left = marbles[0...placement_index]
    right = marbles[placement_index..-1]
    @marbles = left + [marble_to_play] + right

    @current_marble_idx = placement_index
  end

  def increment_player
    @current_player = (current_player + 1) % num_players
  end

  def play_twenty_third_marble
    marble_to_remove_idx = normalize_marble_idx(current_marble_idx - 7)
    marble_to_remove = @marbles.slice!(marble_to_remove_idx)
    @current_marble_idx = normalize_marble_idx(marble_to_remove_idx)

    player_scores[current_player] += (marble_to_play + marble_to_remove)
  end

  def normalize_marble_idx(idx)
    num_marbles = marbles.length
    (idx + num_marbles) % num_marbles
  end
end

# nope
# t_start = Time.now
# p Day9.new(418, 7076900).play!
# t_end = Time.now
# p t_end - t_start
