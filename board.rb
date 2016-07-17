require_relative 'tile.rb'
require 'byebug'

class Board

  attr_reader :grid

  def initialize(grid = Array.new(9) { Array.new(9)})
    @grid = grid
  end

  def [](row, col)
    grid[row][col]
  end

  def []=(row, col, value)
    grid[row][col].value = value
  end

  def inspect
    #over-writing inspect so it doesnt show us the whole board when looking at one tile
  end

  def populate_board
    grid.map! do |row|
      row.map! {|pos| Tile.new}
    end
  end

  def plant_bombs
    bombs = 0
    bomb_coord = []
    until bombs == grid.length + 1
      coord = [rand(0..8),rand(0..8)]
      next if self[*coord].bombed?
      bomb_coord << coord
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
    selected_neighbors = neighbors.select { |coord| coord[0].between?(0, 8) && coord[1].between?(0, 8)}
    selected_neighbors
  end
  # def spread_area(pos)
  #   return [pos] if self[*pos].value.is_a?(Integer)
  #   result = []
  #   neighbors(pos).each do |neighbor|
  #     result += spread_area(neighbor)
  #   end
  # end
  #
  #
  #
  # def flip_spread(array)
  #   array.each do |arr|
  #     self[*arr].flip
  #   end
  # end



    # log = []
    # until empties.all? {|el| self[*el].flipped?}
    #   empties.each do |empty|
    #     neighbors(empty).each do |neighbor|
    #       if self[*neighbor].is_a?(Integer)
    #         fringe << neighbor
    #         self[*neighbor].flip
    #       elsif self[*neighbor] == "*"
    #         fringe << neighbor unless checked.include?(neighbor)
    #       else
    #         empties << neighbor unless checked.include?(neighbor)
    #         self[*neighbor].flip
    #       end
    #     end
    #   end


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
      (0..8).each do |i|
        (0..8).each do |j|
        self[*[i, j]] = num_adjacent_bombs([i, j]) unless self[*[i, j]].value == "*" || num_adjacent_bombs([i, j]) == 0
      end
    end
  end

  def flip_tile(pos)
    return self[*pos] if self[*pos].flipped?
    return self[*pos] if self[*pos].flagged?
    self[*pos].flip
    if !self[*pos].bombed? && num_adjacent_bombs(pos) == 0
      neighbors(pos).each {|pos| flip_tile(pos)}
    end
  end

  def render
      puts "    " + (0..8).to_a.join(" ")
    grid.each_with_index do |row, i|
      puts "#{i} | " + row.map { |tile| tile.display }.join(' ')
    end
  end

  def lost?
    grid.flatten.select { |el| el.flipped? }.any? { |tile| tile.value == "*" }
  end

  def won?
    grid.flatten.any? { |tile| tile.bombed? && tile.flipped? }
  end

end
