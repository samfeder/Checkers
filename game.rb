require_relative 'board'

require 'colorize'

puts "I am now red.".red
puts "I am now blue.".green
puts "I am a super coder".yellow

class Game

  attr_reader :board, :current_player, :player

  def initialize
    @board = Board.new
    @players = {
      white: HumanPlayer.new(:white)
      black: HumanPlayer.new(:black)
    }
  end

end

class HumanPlayer

  def initialize(color)
    @color = color
  end

  def play_move(board)
    puts board.render
    puts "#{color}'s turn"


  end

  def get_position(color)

  end

end