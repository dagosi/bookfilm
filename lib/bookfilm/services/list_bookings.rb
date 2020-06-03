require 'dry/transaction'

module Bookfilm
  class ListBookings
    include Dry::Transaction

    step :validate
    step :list

    private

    def validate(params)
      if params[:start_date] < params[:end_date]
        Success(params)
      else
        Failure('End date must be after start date')
      end
    end

    def list(params)
      bookings = Booking.between(params[:start_date], params[:end_date]).map(&:values)
      Success(bookings)
    end
  end
end
