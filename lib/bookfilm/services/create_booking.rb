class CreateBooking
  BOOKING_CAP = 10

  def initialize(params)
    @params = params
    @film_id = params[:booking][:fiml_id]
    @errors = []
  end

  def call(params)
    validate
    return false unless valid?

    insert(params[:booking])
    film
  end

  private

  def valid?
    @errors.empty
  end

  def validate
    @errors << "There aren't more seats for #{film_name}" unless can_create_booking_for_film?(film_id)
  end

  def film
    @film ||= Film.find(@film_id)
  end

  def film_name
    film.name
  end

  def can_create_booking_for_film?(film_id)
    Booking.where(film_id: film_id).count <= BOOKING_CAP
  end
end
