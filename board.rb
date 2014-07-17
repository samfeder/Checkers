require_relative 'pieces'

class Board

  def initialize
    fill_board
    death_toll = {white: 0, black: 0}
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
    pos.all? { |coord| coord.between?(0, 7) && (coord[0] + coord[1]).is_even? }
  end

  def fill_rows(color)
    odd_rows = [1,3,5,7]
    even_rows = [0,2,4,6]
    i = (color == :white) ? [7,6,5] : [0,1,2]
    i.each do |row|
      j = (i.is_even?) ? even_rows : odd_rows
      j.each { |j| Piece.new(color, self, [i,j])}
    end
  end

  def fill_board
    @rows = Array.new(8) {Array.new(8)}
    [:white, :black].each {|color| fill_rows(color)}
  end

end