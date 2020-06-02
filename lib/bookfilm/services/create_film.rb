require 'dry/transaction'

module Bookfilm
  class CreateFilm
    include Dry::Transaction

    step :create

    private

    def create(params)
      film = Film.create(params)
      Success(film)
    end
  end
end
