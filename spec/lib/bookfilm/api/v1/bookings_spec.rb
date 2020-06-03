require 'spec_helper'

describe 'Bookings endpoint' do
  describe 'GET /bookings' do
  end

  describe 'POST /bookings' do
    context 'when there are seats available' do
      it 'creates a booking for a film on a date' do
        star_wars = FactoryBot.create(:film, :star_wars, rolling_days: ['monday'])
        booking_params = {
          booking: {
            date: '2020-10-05',
            film_id: star_wars.id
          }
        }

        post '/api/v1/bookings', booking_params

        expect(JSON.parse(last_response.body)).to eq({
          "date" => "2020-10-05",
          "film_id" => 1,
          "id" => 1
        })
        expect(last_response.status).to eq(201)
      end

      it 'creates a booking with the last seat for a film' do
        star_wars = FactoryBot.create(:film, :star_wars, rolling_days: ['monday'])
        FactoryBot.create_list(:booking, 9, film_id: star_wars.id)

        booking_params = {
          booking: {
            date: '2020-10-05',
            film_id: star_wars.id
          }
        }

        post '/api/v1/bookings', booking_params

        expect(JSON.parse(last_response.body))
          .to include("date" => "2020-10-05", "film_id" => star_wars.id)
        expect(last_response.status).to eq(201)
      end
    end

    context 'when there no seats available' do
      it 'returns a 422 with a proper message' do
        film = FactoryBot.create(:film, :star_wars, rolling_days: ['monday'])
        FactoryBot.create_list(:booking, 10, film_id: film.id)

        booking_params = {
          booking: {
            date: '2020-10-05',
            film_id: film.id
          }
        }
        post '/api/v1/bookings', booking_params

        expect(JSON.parse(last_response.body)).to eq({ "errors" => 'The theater is full!' })
        expect(last_response.status).to eq(422)
      end
    end

    context 'when the film rolling week day does not align with the date' do
      it 'returns a 422 with a proper message' do
        star_wars = FactoryBot.create(:film, :star_wars, rolling_days: ['saturday', 'wednesday'])

        booking_params = {
          booking: {
            date: '2020-10-05', # This is always a Monday unless you change your calendar.
            film_id: star_wars.id
          }
        }

        post '/api/v1/bookings', booking_params

        expect(JSON.parse(last_response.body))
          .to eq({
            "errors" => {
              "film_id" => ["film does not play on 2020-10-05"]
            }
          })
        expect(last_response.status).to eq(422)
      end
    end

    context 'when there is no date in the params' do
      it 'returns a 422 with a proper message' do
        star_wars = FactoryBot.create(:film, :star_wars)

        booking_params = {
          booking: {
            date: '',
            film_id: star_wars.id
          }
        }

        post '/api/v1/bookings', booking_params
        expect(last_response.status).to eq(400)
        expect(JSON.parse(last_response.body)).to eq({ "error" => "booking[date] is empty" })
      end
    end

    context 'when the film id does not correspond to any film' do
      it 'returns a 422 error with a proper message' do
        booking_params = {
          booking: {
            date: '2020-10-05', # This is always a Monday unless you change your calendar.
            film_id: 999999
          }
        }

        post '/api/v1/bookings', booking_params
        expect(last_response.status).to eq(422)
        expect(JSON.parse(last_response.body))
          .to eq({
            "errors" => {
              "film_id" => ["film does not exist"]
            }
          })
      end
    end
  end
end
