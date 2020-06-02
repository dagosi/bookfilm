require 'grape'
require 'bookfilm'

module Bookfilm
  class API < Grape::API
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
            requires :name, type: String, allow_blank: { value: false }
            requires :description, type: String, allow_blank: { value: false }
            requires :image_url, type: String, allow_blank: { value: false }
            requires :rolling_days,
              type: Array[String],
              values: {
                value: ->(day) { Date::DAYNAMES.include?(day.capitalize) },
                message: 'has an invalid day'
              }
          end
        end
        post do
          film_creation = CreateFilm.new.call(params[:film])

          if film_creation.success?
            film_creation.success
          else
            error!({ errors: film_creation.failure }, 422)
          end
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
end
