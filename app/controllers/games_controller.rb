require 'open-uri'
# frozen_string_literal: true
class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('a'..'z').to_a.sample.upcase
    end
    @letters
    session[:total_score] = 0 unless session[:total_score].present?
  end

  def score
    @letters_string = params[:grid]
    @word = params[:word].upcase
    if included?(@word, @letters_string)
      results
      if english_word?(@word)
      else @result = 'It is not a valid English word!'
      end
    else @result = 'The word can’t be built out of the original grid!'
    end
  end

  def results
    @result = 'The word is valid!'
    @score = @word.length
    @time = (Time.now - Time.new(params[:time])) / 1000
    session[:total_score] += @score
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def included?(word, letters_string)
    word.chars.all? do |letter|
      word.count(letter) <= letters_string.count(letter)
    end
  end
end
