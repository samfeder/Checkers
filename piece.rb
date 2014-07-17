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

      position = [current_x + dx, current_y + dy]
      next unless board.valid_pos?(position)

      if board[position].nil?
        moves << position
        p moves
      elsif board[position].color != color
        jump_pos = position.map { |loc| loc *=2}
        moves << jump_pos if board.empty?(jump_pos)
        p moves
      end
    end
  end

  def perform_slide(from_pos, to_pos)
    return false if !moves.include?(to_pos)
    @board[to_pos] = self
    @board[from_pos] = nil
    position = to_pos

    @promoted = true if maybe_promote?
    true
  end
# TODO HAS POSSS!!!
  def perform_jump(from_pos, to_pos)
    return false if !moves.include?(pos)
    @board.kill_total[@board[from_pos].color] += 1
    @board[to_pos] = self
    @board[from_pos] = nil
    position = to_pos

    @promoted = true if maybe_promote?
    true
  end

  def maybe_promote?
    true if (color == :white && pos[i] == 0) || (color == :black && pos[i] == 7)
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

