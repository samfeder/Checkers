require_relative 'board'




class Game

  attr_reader :board, :current_player, :player

  def initialize
    @board = Board.new
    @players = {
      white: HumanPlayer.new(:white),
      black: HumanPlayer.new(:black)
    }
    @current_player = :white
    play
  end

  def play
    until over?
      p board
      @players[@current_player].play_move(board)
      @current_player = (@current_player == :white) ? :black : :white
    end

    puts board.render
    puts "#{@current_player} has lost! :("
  end

  def over?
    false
  end



end

class HumanPlayer

  attr_accessor :color

  def initialize(color)
    @color = color
  end

  def play_move(board)
    begin
      puts board.render
      puts "#{@color}'s turn"
      from_pos = get_position("Provide ROW+COL of moving piece: ").flatten
      raise InvalidSelection if !board.valid_pos?(from_pos)
      raise BadOwnership if !valid_owner?(board, color, from_pos)
      raise MovelessPiece if !valid_selection?(board, from_pos)
      puts "You have these moves available #{board[from_pos].moves}"
      to_pos = get_position("Provide ROW+COL of new tile: ")
      if to_pos.length == 1
        to_pos.flatten!
        raise InvalidSelection if !board.valid_pos?(to_pos)
        raise BadMove if !valid_move?(board, from_pos, to_pos)
        board.make_move!(color, from_pos, to_pos)
      else
        raise BadMove if !all_valid_moves?(to_pos)
        to_pos.each do |jump_num|board.make_move!(color, from_pos, jump_num)
          from_pos = jump_num
        end
      end
    rescue InvalidSelection
      puts "That is not a valid tile."
      retry
    rescue BadOwnership
      puts "You do not have a piece there."
      retry
    rescue MovelessPiece
      puts "That piece has no moves."
      retry
    rescue BadMove
      puts "That is not a valid move."
      retry
    end

  end

  all_valid_moves?(to_pos)
  #in this case, to_pos comes in as an array of strung together moves.
  #first thing to check is if the move is a jump
  #then if it is a jump, dup board and check legality.
  end

  def valid_move?(board, from_pos, to_pos)
    board[from_pos].moves.include?(to_pos)
  end

  def valid_owner?(board, color, from_pos)
    !(board[from_pos].nil? && board[from_pos].color != color)
  end

  def valid_selection?(board, from_pos)
    board[from_pos].moves != []
  end

  def get_position(prompt)
    puts prompt
    coord = []
    coord_list = []
    moves_list = gets.chomp.split(" ")
    moves_list.each do |move|
      move.split(',').map {|coord_s| coord << Integer(coord_s)}
      coord_list << coord
      coord = []
    end
    coord_list
  end

end

class InvalidSelection < StandardError
end
class MovelessPiece < StandardError
end
class BadMove < StandardError
end
class BadOwnership < StandardError
end

game = Game.new