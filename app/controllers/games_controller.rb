# frozen_string_literal: true

require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @answer = params[:answer]
    @grid = params[:grid]

    scoring_method(@answer, @grid)
  end

  def in_the_grid?(attempt, grid)
    letters = attempt.upcase.chars
    letters.all? { |letter| letters.count(letter) <= grid.count(letter) }
  end

  def attempt_valid?(attempt)
    attempt_url = open("https://wagon-dictionary.herokuapp.com/#{attempt}")
    attempt_hash = JSON.parse(attempt_url.read)
    attempt_hash['found']
  end

  def scoring_method(answer, grid)
    @result = { score: 0, message: '' }
    if attempt_valid?(answer) == false
      @result[:message] = "Your answer #{answer.upcase} is not an English word"
    elsif in_the_grid?(answer, grid) == false
      @result[:message] = "Your answer #{answer.upcase} is not in the grid"
    else
      @result[:score] = answer.length
      @result[:message] = "Well done. #{answer.upcase} is a great answer!"
    end

    @result
  end
end
