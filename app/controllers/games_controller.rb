class GamesController < ApplicationController
  def new
  	alphabet = [*("A".."Z")]
  	@letters = []
  	for i in (1..9) do
      sorted_number = rand(26)
  		@letters << alphabet[sorted_number]
  	end
  end

  def score
  end
end
