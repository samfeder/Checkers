require_relative 'piece'
require 'colorize'


class Board

  attr_accessor :kill_total

  def inspect

  end

  def initialize
    fill_board
    @kill_total = {white: 0, black: 0}
  end

  def [](pos)
    i, j = pos
    @rows[i][j]
  end

  def []=(pos, piece)


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

  def make_move!(color, from_pos, to_pos)
    piece = self[from_pos]
    @kill_total[self[to_pos].color] += 1 if !self[to_pos].nil?
    self[to_pos] = piece
    piece.position = to_pos
    piece.perform_slide(from_pos, to_pos) if ((from_pos[0] - to_pos[0]).abs == 1)
    piece.perform_jump(from_pos, to_pos) if ((from_pos[0] - to_pos[0]).abs == 2)
    self[from_pos] = nil
  end

  def render
    color_arr = [:light_black, :light_red]
     print "\n\n"
     @rows.each_with_index do |row, i1|
       print "\t\t #{i1}"
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
     print "\t\t  0 1 2 3 4 5 6 7"
     print "\n\n"
     print "Kill Total: #{@kill_total}"
  end

    protected

  def fill_board
    @rows = Array.new(8) {Array.new(8)}
    [:white, :black].each {|color| fill_rows(color)}
  end



end