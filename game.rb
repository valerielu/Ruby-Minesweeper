require_relative 'board.rb'

class Game
  attr_reader :board

  def initialize(board)
    @board = board
  end

  def play
    board.populate_board
    board.plant_bombs
    board.populate_num
    board.render

    until board.lost? || board.won?
       play_turn
    end

    if board.lost?
      puts "That's a bomb!"
      (0..8).each do |i|
        (0..8).each do |j|
          board[*[i, j]].flip
        end
      end
      board.render

    elsif board.won?
      puts "You win!"
    end
  end

  def play_turn
    pos = get_pos
    perform_move(pos, get_action)
    board.render
  end

  def get_pos
    puts "Pick your position"
    pos = parse_pos(gets.chomp)
  end

  def get_action
    puts "What do you want to do with it? (R for reveal, F for flag)"
    action = gets.chomp.upcase
  end


  def perform_move(pos, action)
    if action == "R"
      board.flip_tile(pos)
    elsif action == "F"
      board[*pos].flag
    end
  end

  def parse_pos(pos)
    pos.split(',').map(&:to_i)
  end

end


if __FILE__ == $PROGRAM_NAME
  board = Board.new
  game = Game.new(board)
  game.play
end
