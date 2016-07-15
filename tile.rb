require 'colorize'

class Tile

  attr_accessor :value

  def initialize(value = " ")
    @value = @flipped
    @flipped = false, @bombed = false, @flagged = false
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
