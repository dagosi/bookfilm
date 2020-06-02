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
      VALIDATION[:required].each do |field|
        ERRORS << "#{field} is blank" if params.fetch(field).nil? || params.fetch(field).empty?
      end

      if ERRORS.empty?
        Success(params)
      else
        Failure(ERRORS)
      end
    end

    def create(params)
      film = Film.create(params)
      Success(film)
    end
  end
end
