class Booking < AppModel
  many_to_one :film

  def validate
    super
    errors.add(:film_id, "film does not exist") and return unless film
    errors.add(:film_id, "film does not play on #{date}") unless film.plays_on?(date)
  end
end
