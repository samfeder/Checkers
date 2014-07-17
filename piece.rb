# -*- coding: utf-8 -*-
require 'colorize'

class Piece

  attr_reader :color, :board
  attr_accessor :position, :promoted

  MOVES =[[1,1],[1,-1],[-1,-1],[-1,1]]

  def initialize(color, board, position, promoted = false)
    @color = color
    @board = board
    @position = position
    @promoted = promoted
  end


  def render
    {white: "⚪", black: "⚫"}[color]
  end

  def moves
    moves = []
    move_diffs.each_with_object([]) do |(dx, dy), moves|
      current_x, current_y = position
      #p "cur x, dx, cur y, dy #{current_x} #{dx} #{current_y} #{dy}"
      position = [current_x + dx, current_y + dy]
      next unless board.valid_pos?(position)

      if board[position].nil?
        moves << position
      elsif board[position].color != color
        jump_pos = [current_x + (dx*2), current_y + (dy*2)]
        moves << jump_pos if board[jump_pos].nil? && board.valid_pos?(jump_pos)
      end
    end
  end

  def perform_slide(from_pos, to_pos)
    @board[to_pos] = self
    @board[from_pos]= to_pos
    position = to_pos

    @promoted = true if maybe_promote?(to_pos)
    true
  end

  def perform_jump(from_pos, to_pos)
    @board.kill_total[@board[to_pos].color] += 1
    @board[to_pos] = self
    @board[from_pos] = to_pos
    position = to_pos
    @board[kill_pos(from_pos, to_pos)] = nil
    @promoted = true if maybe_promote?(to_pos)
    true
  end

  def kill_pos(from_pos, to_pos)
    kill_spot = []
    diff = [from_pos[0] - to_pos[0], from_pos[1] - to_pos[1]]
    to_pos.each_index { |i| kill_spot << to_pos[i] + diff[i]/2}
    kill_spot
  end

  def maybe_promote?(to_pos)
    true if (color == :white && to_pos[0] == 0) || (color == :black && to_pos[0] == 7)
  end



  def move_diffs
    #potential refactor, triple ifs could get messi.
    if @promoted == true
      return MOVES
    elsif color == :white
      MOVES.reverse.take(2)
    else
      MOVES.take(2)
    end
  end
end

