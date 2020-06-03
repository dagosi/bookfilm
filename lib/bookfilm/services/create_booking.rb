require 'dry/transaction'

module Bookfilm
  class CreateBooking
    include Dry::Transaction

    BOOKING_CAP = 10

    step :validate
    step :create

    private

    def validate(params)
      booking = Booking.new(params)
      film = booking.film

      if film.seats_available?(booking.date)
        Success(booking)
      else
        Failure('The theater is full!')
      end
    end

    def create(booking)
      booking.save
      Success(booking.values)
    end
  end
end
