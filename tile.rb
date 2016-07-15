require 'colorize'

class Tile

  attr_accessor :value

  def initialize(value = " ")
    @value = value
    @flipped = false
    @bombed = false
    @flagged = false
  end

  def bombed?
    @bombed
  end

  def flagged?
    @flagged
  end

  def flipped?
    @flipped
  end

  def bomb


    @bombed = true

  end

  def flag
    @flagged = true
  end

  def flip
    @flipped = true

    # if !bombed? && num_adjacent_bombs == 0
    #     neighbors.each { |tile| tile.flip}
    # end
  end

  def display
    if self.flipped?
      "#{@value}"
    elsif self.flagged?
      "F"
    else
      "#"
    end
  end


end
