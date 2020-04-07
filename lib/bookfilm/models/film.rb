class Film < Sequel::Model
  class << self
    def index(params)
      by_day = params[:day]

      films =
        if by_day.present?
          Film.where(Sequel.like(:rolling_days, "%#{by_day}%"))
        else
          Film.select
        end

      films.map(&:values)
    end

    def create(params)
      film_id = insert(params[:film])
      where(id: film_id).first.values
    end
  end
end
