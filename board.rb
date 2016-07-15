require_relative 'tile.rb'
require 'byebug'

class Board

  attr_reader :grid

  # def self.empty_grid
  #
  # end

  def initialize(grid = Array.new(9) { Array.new(9)})
    @grid = grid
  end

  def [](row, col)
    # x, y = pos
    grid[row][col]
  end

  def []=(row, col, value)
    # x, y = pos
    grid[row][col].value = value
  end



  def populate_board
    grid.map! do |row|
      row.map! {|pos| Tile.new}
    end
  end

  def plant_bombs
    bombs = 0
    @bomb_coord = []
    until bombs == grid.length + 1
      coord = [rand(0..8),rand(0..8)]
      # byebug
      next if self[*coord].bombed?
      @bomb_coord << coord
      self[*coord] = "*"
      self[*coord].bomb
      bombs += 1
    end
  end

  def neighbors(pos)
    top_left = [pos[0] - 1, pos[1] - 1]
    top = [pos[0] - 1, pos[1]]
    top_right = [pos[0] - 1, pos[1] + 1]
    right = [pos[0], pos[1] + 1]
    bottom_right = [pos[0] + 1, pos[1] + 1]
    bottom = [pos[0] + 1, pos[1]]
    bottom_left = [pos[0] + 1, pos[1] - 1]
    left = [pos[0], pos[1] - 1]

    neighbors = [top_left, top, top_right, right, bottom_right, bottom, bottom_left, left]
    neighbors.select! { |coord| coord[0].between?(0, 8) && coord[1].between?(0, 8)}


  end

  def spread_area(pos)
    # fringe = []
    # empties = [pos]
    # # log = []
    # until empties.all? {|el| self[*el].flipped?}
    #   empties.each do |empty|
    #     neighbors(empty).each do |neighbor|
    #       if self[*neighbor].is_a?(Integer)
    #         fringe << neighbor
    #         self[*neighbor].flip
    #       elsif self[*neighbor] == "*"
    #         fringe << neighbor unless fringe.include?(neighbor)
    #       else
    #         empties << neighbor unless empties.include?(neighbor)
    #         self[*neighbor].flip
    #       end
    #     end
    #   end
    #   if !bombed? && num_adjacent_bombs == 0
    #     neighbors.each { |tile| spread_area(tile)}
    #   end
      # empty.pop
      # spread_area(empty)
    # end

    end




  def num_adjacent_bombs(pos)
    num = 0
    touching = neighbors(pos)
    # byebug
    touching.each do |neighbor|
        num += 1 if self[*neighbor].bombed?
    end
    num
  end

  def populate_num
    # grid.each_with_index do |row, i|
      (0..8).each do |i|
        (0..8).each do |j|
          puts "column #{j} "

    #   row.each_with_index do |pos, j|
        # self[*pos] = " " if num_adjacent_bombs(pos) == 0
        self[*[i, j]] = num_adjacent_bombs([i, j]) unless self[*[i, j]].value == "*" || num_adjacent_bombs([i, j]) == 0
      end
      puts "row #{i}"
    end
  end

  def render
    grid.each do |row|
      puts row.map { |tile| tile.display }.join(' ')
    end
  end

  def lost?
    grid.flatten.select { |el| el.flipped? }.any? { |tile| tile.value == "*" }
  end

  def won?
    grid.flatten.select { |el| el.flipped? }.none? { |tile| tile.value == "*" }
  end



end
