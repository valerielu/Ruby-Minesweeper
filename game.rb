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
      puts "You lose"
    else
      puts "You win!"
    end
  end

  def play_turn
    get_pos
    board.spread_area
    perform_move
    board.render
  end

  def get_pos
    puts "Pick your position"
    pos = parse_pos(gets.chomp)
    puts "What do you want to do with it? (T for turn, F for flag)"
    action = gets.chomp
  end

  def perform_move(pos, action)
    if action == "T"
      board[pos].flip
    elsif action == "F"
      board[pos].flag
    end
  end

end


if __FILE__ == $PROGRAM_NAME
  board = Board.new
  game = Game.new(board)
  game.play
end
