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
    @value = "*"
  end

  def flag
    @flagged = true
  end

  def flip
    @flipped = true
  end

  def display
    if self.flipped?
      "#{@value == "*" ? @value.to_s.colorize(:red) : @value.to_s.colorize(:green)}"
    elsif self.flagged?
      "F".colorize(:yellow)
    else
      "#"
    end
  end


end
