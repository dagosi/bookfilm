require 'grape'
require 'bookfilm'

class Routing < Grape::API
  format :json
  prefix :api

  namespace :v1 do
    resource :films do
      params do
        optional :day, type: String
      end
      get do
        Film.index declared(params)
      end

      params do
        requires :film, type: Hash do
          requires :name, type: String
          requires :description, type: String
          requires :image_url, type: String
          requires :rolling_days, type: Array[String]
        end
      end
      post do
        Film.create declared(params)
      end
    end

    resource :bookings do
      params do
        requires :booking, type: Hash do
          requires :date, type: Date
          requires :film_id, type: Integer
        end
      end
      post do
        Booking.create declared(params)
      end
    end
  end
end
