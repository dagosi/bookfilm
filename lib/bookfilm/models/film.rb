class Film < Sequel::Model
  class << self
    def search_by_day(params)
      week_day = params[:day]
      films = Film.where(Sequel.ilike(:rolling_days, "%#{week_day}%"))

      films.map(&:values)
    end
  end

  def stringify_keys
    values.stringify_keys
  end
end
