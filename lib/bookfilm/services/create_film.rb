require 'dry/transaction'

module Bookfilm
  class CreateFilm
    include Dry::Transaction

    ERRORS = []
    VALIDATION = {
      required: [:name, :description, :image_url, :rolling_days]
    }

    step :validate
    step :create

    private

    def validate(params)
      Success(params)
    end

    def create(params)
      film = Film.create(params)
      Success(film)
    end
  end
end
