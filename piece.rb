# -*- coding: utf-8 -*-
require 'colorize'

class Piece

  attr_reader :color

  MOVES =[[1,1],[1,-1],[-1,-1],[-1,1]]

  def initialize(color, board, position, promoted = false)
    @color = color
    @board = board
    @position = position
    @promoted = promoted
  end

  def inspect

  end

  def render
    {white: "⚪", black: "⚫"}[color]
  end

  def moves
    moves_diffs.each_with_object([]) do |(dx, dy), moves|
      current_x, current_y = pos
      pos = [current_x + dx, cur_y + dy]

      next unless board.valid_pos?(pos)

      if board.empty?(pos)
        moves << pos
      elsif board[pos].color != color
        jump_pos = pos.map { |loc| loc *=2}
        moves << jump_pos if board.empty?(jump_pos)
      end
    end
  end

  def perform_slide(from_pos, to_pos)
    return false if !moves.include?(pos)
    @board[to_pos] = self
    @board[from_pos] = nil
    @position = to_pos

    @promoted = true if maybe_promote?
    true
  end

  def perform_jump(from_pos, to_pos)
    return false if !moves.include?(pos)
    @board.death_toll[@board[pos].color] += 1
    @board[to_pos] = self
    @board[from_pos] = nil
    @position = to_pos

    @promoted = true if maybe_promote?
    true
  end

  def maybe_promote?
    true if (color == :white && pos[i] == 0) || (color == :black && pos[i] == 7)
  end



  def move_diffs
    #potential refactor, triple ifs could get messi.
    if promoted == true
      return MOVES
    elsif color == :white
      MOVES.reverse.take(2)
    else
      MOVES.take(2)
    end
  end
end

