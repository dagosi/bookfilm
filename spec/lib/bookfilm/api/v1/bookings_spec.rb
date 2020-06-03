require 'spec_helper'

describe 'Bookings endpoint' do
  describe 'GET /bookings' do
    def stringify_date(bookings)
      bookings.map do |booking|
        values = booking.values
        values[:date] = values[:date].to_s
        values.stringify_keys
      end
    end

    context 'when params are valid' do
      it 'returns all booking in the range of dates' do
        start_date = '2020-05-01'
        end_date = '2020-10-10'

        bookings_in_range =
          3.times.map do
            FactoryBot.create(
              :booking, :with_film_on_date, date: Faker::Date.between(from: start_date, to: end_date)
            )
          end

        before_booking = FactoryBot.create(:booking, :with_film_on_date, date: Date.parse('2020-01-31'))
        after_booking = FactoryBot.create(:booking, :with_film_on_date, date: Date.parse('2020-12-31'))

        params = {
          start_date: '2020-05-01',
          end_date: '2020-10-10'
        }

        get '/api/v1/bookings', params

        expect(last_response.status).to eq(200)

        response_body = JSON.parse(last_response.body)
        expect(response_body).to include(*stringify_date(bookings_in_range))
        expect(response_body).not_to include(*stringify_date([before_booking]))
        expect(response_body).not_to include(*stringify_date([after_booking]))
      end
    end

    context 'when params are invalid' do
      context 'when params are blank' do
        it 'returns a 400 error with a proper message' do
          params = {
            start_date: '',
            end_date: ''
          }

          get '/api/v1/bookings', params

          expect(last_response.status).to eq(400)
          expect(JSON.parse(last_response.body))
            .to eq({ "error" => "start_date is empty, end_date is empty" })
        end
      end

      context 'when start date is after the end date' do
        it 'returns a 422 error with a message' do
          params = {
            start_date: '2020-12-31',
            end_date: '2020-01-01'
          }

          get '/api/v1/bookings', params
          
          expect(last_response.status).to eq(422)
          expect(JSON.parse(last_response.body))
            .to eq({ "error" => "End date must be after start date" })
        end
      end
    end
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

        expect(JSON.parse(last_response.body)).to include({
          "date" => "2020-10-05",
          "film_id" => star_wars.id
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

        expect(JSON.parse(last_response.body)).to eq({ "error" => 'The theater is full!' })
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
            "error" => {
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
            "error" => {
              "film_id" => ["film does not exist"]
            }
          })
      end
    end
  end
end
