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
    selected_neighbors = neighbors.select { |coord| coord[0].between?(0, 8) && coord[1].between?(0, 8)}
    selected_neighbors

  end


  def not_in_all_checked(array)
    array.reject {|el| @all_checked.include?(el)}
  end

  def spread_area(pos)
    @all_checked = [pos]
    fringe = []
    @current_neighbors = neighbors(pos)

    until @current_neighbors.empty?
      byebug
      @all_checked += not_in_all_checked(@current_neighbors)
      new_neighbors = []
      @current_neighbors.each do |one|
        fringe << one if self[*one].value.is_a?(Integer)
        new_neighbors += not_in_all_checked(neighbors(one))
      end
      @all_checked += not_in_all_checked(new_neighbors)
      @all_checked += not_in_all_checked(fringe)
      @current_neighbors = new_neighbors
    end

    @all_checked.each do |positions|
      self[*positions].flip
    end


    #
    #
    # new_neighbors.each do |i|
    #   spread_area(i) unless @all_checked.empty?
    # end
    #
    # @all_checked.each do |i|
    #   grid[i].flip
    # end



      # new_neighbors.each do |i|
      #   @all_checked += i unless @all_checked.include?(i)
      #   spread_area(i)
      # end
      #
      # @all_checked.each do |i|
      #   grid[i].flip
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
      (0..8).each do |i|
        (0..8).each do |j|
        self[*[i, j]] = num_adjacent_bombs([i, j]) unless self[*[i, j]].value == "*" || num_adjacent_bombs([i, j]) == 0
      end
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
    return false if grid.flatten.none? { |el| el.flipped? }
    grid.flatten.reject { |el| el.bombed? }.all? { |tile| tile.flipped? }
  end

end
