require 'dry/transaction'

module Bookfilm
  class CreateFilm
    include Dry::Transaction

    step :sanitize
    step :create

    private

    def sanitize(params)
      params[:rolling_days].map(&:downcase!)

      Success(params)
    end

    def create(params)
      film = Film.create(params)
      Success(film.values)
    end
  end
end
