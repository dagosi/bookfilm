class Booking < AppModel
  many_to_one :film

  dataset_module do
    def between(start_date, end_date)
      where { date >= start_date }.where { date <= end_date }
    end
  end

  def validate
    super
    errors.add(:film_id, "film does not exist") and return unless film
    errors.add(:film_id, "film does not play on #{date}") unless film.plays_on?(date)
  end
end
