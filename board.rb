require_relative 'piece'
require 'colorize'

puts "I am yellow".yellow


class Board

  def initialize
    fill_board
    @death_toll = {white: 0, black: 0}
    render
  end

  def [](pos)
    raise 'invalid pos' unless valid_pos?(pos)

    i, j = pos
    @rows[i][j]
  end

  def []=(pos, piece)
    raise 'invalid pos' unless valid_pos?(pos)

    i, j = pos
    @rows[i][j] = piece
  end

  def valid_pos?(pos)
    pos.all? { |coord| coord.between?(0, 7) }
  end

  def fill_rows(color)
    odd_rows = [1,3,5,7]
    even_rows = [0,2,4,6]
    color == :white ? row = [7,6,5] : row = [0,1,2]
    row.each do |i|
      j = (i.even?) ? even_rows : odd_rows
      j.each do |j|
        self[[i,j]] = Piece.new(color, self, [i,j])
      end
    end
  end

  def fill_board
    @rows = Array.new(8) {Array.new(8)}
    [:white, :black].each {|color| fill_rows(color)}
  end

  def render
    color_arr = [:light_red, :light_black]
     print "\n\n"
     @rows.each_with_index do |row, i1|
       print "\t\t #{i1+1}"
       row.each_with_index do |tile, i2|
         if tile.nil?
           print "  ".colorize(:background => color_arr[0])
           color_arr.rotate![1]
         else
           print "#{tile.render} ".colorize(:background => color_arr[0])
           color_arr.rotate![1]
         end
       end
       color_arr.rotate![1]
       print "\n"
     end
     print "\t\t  A B C D E F G H"
     print "\n\n"
  end

end