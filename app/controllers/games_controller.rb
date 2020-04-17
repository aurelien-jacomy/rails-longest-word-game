class GamesController < ApplicationController
  require 'open-uri'
  require 'date'

  def new
    alphabet = [*('A'..'Z')]
    @letters = []
    9.times do
      sorted_number = rand(26)
      @letters << alphabet[sorted_number]
    end
    @start_time = Time.now.to_i
  end

  def score
    grid = params[:grid].split('')
    word = params[:word].upcase
    @spent_time = Time.now.to_i - params[:start_time].to_i
    @score = 0
    if respect_grid?(word, grid)
      if english?(word)
        @score = score_calculation(word)
        @message = "<strong>Congratulations</strong>! You just scored <strong>#{@score}</strong> points!"
      else
        @message = "Sorry but <strong>#{word}</strong> doesn't seem to be an english word"
      end
    else
      @message = "Sorry but you can't build #{word} with #{grid.join(', ')}"
    end
  end

  def respect_grid?(word, grid)
    grid_hash = letters_count(grid)
    word_hash = letters_count(word.split(''))
    word_hash.each do |key, value|
      return false if grid_hash[key].nil?
      return false if grid_hash[key] < value
    end
    true
  end

  def letters_count(array)
    letters_hash = {}
    array.each do |letter|
      if letters_hash[letter].nil?
        letters_hash[letter] = 1
      else
        letters_hash[letter] += 1
      end
    end
    letters_hash
  end

  def english?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    answer = JSON.parse(open(url).read)
    answer['found']
  end

  def score_calculation(word, time = 1)
    [word.length * 4 * (1 - time.fdiv(20)), 1].max.round
  end
end
