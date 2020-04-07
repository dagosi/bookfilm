class Booking < Sequel::Model
  class << self
    BOOKING_CAP = 10

    def create(params)
      film_id = params[:booking][:fiml_id]

      return "There aren't more seats for #{film_id}" unless can_create_booking_for_film?(film_id)

      insert(params[:booking])
    end

    private

    def can_create_booking_for_film?(film_id)
      Booking.where(film_id: film_id).count <= BOOKING_CAP
    end
  end
end
