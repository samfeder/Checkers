require_relative 'board'

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


end