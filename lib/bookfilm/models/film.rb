class Film < AppModel
  one_to_many :bookings

  BOOKING_CAP = 10

  dataset_module do
    def by_day(day)
      day = day.underscore
      where(Sequel.pg_array_op(:rolling_days).contains("{#{day}}"))
    end
  end

  class << self
    def search_by_day(params)
      by_day(params[:day]).map(&:values)
    end
  end

  def seats_available?(date)
    occupancy_on(date) < BOOKING_CAP
  end

  def plays_on?(str_date)
    rolling_wdays = rolling_days.map { |rolling_day| Date.parse(rolling_day).wday }
    rolling_wdays.include? Date.parse(str_date).wday
  end

  private

  def occupancy_on(date)
    bookings_dataset.where(date: date).count
  end
end
