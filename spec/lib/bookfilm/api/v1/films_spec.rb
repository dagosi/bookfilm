require 'spec_helper'

describe 'Films endpoint' do
  describe 'POST /film' do
    let(:film_params) do
      {
        film: {
          name: 'The Terminator',
          description: 'The Terminator is a 1984 American science fiction film directed by James Cameron. It stars Arnold Schwarzenegger as the Terminator, a cyborg assassin sent back in time from 2029 to 1984 to kill Sarah Connor (Linda Hamilton), whose son will one day become a savior against machines in a post-apocalyptic future. Michael Biehn plays Kyle Reese, a reverent soldier sent back in time to protect Sarah',
          image_url: 'https://en.wikipedia.org/wiki/The_Terminator#/media/File:Terminator1984movieposter.jpg',
          rolling_days: ['monday', 'saturday']
        }
      }
    end

    context 'when the params are valid' do
      it 'returns a 201 status with message' do
        post '/api/v1/films', film_params

        params = film_params[:film]
        expect(JSON.parse(last_response.body))
          .to include({
              name: params[:name],
              description: params[:description],
              image_url: params[:image_url],
              rolling_days: params[:rolling_days]
            }.stringify_keys)
        expect(last_response.status).to eq(201)
      end
    end

    context 'when there is a missing param' do
      it 'returns a 400 status with message' do
        film_params[:film].delete(:rolling_days)

        post '/api/v1/films', film_params

        expect(last_response.status).to eq(400)
        expect(JSON.parse(last_response.body)).to eq({ "error" => 'film[rolling_days] is missing'})
      end
    end

    context 'when there is an invalid param' do
      it 'returns a 400 status with message' do
        film_params[:film][:name] = nil

        post '/api/v1/films', film_params

        expect(last_response.status).to eq(400)
        expect(JSON.parse(last_response.body)).to eq({ "error" => "film[name] is empty" })
      end

      context 'when there is a wrong rolling day' do
        it 'returns a 400 with a message' do
          film_params[:film][:rolling_days] = ['mondayday', 'sunday', 'friday']

          post '/api/v1/films', film_params

          expect(last_response.status).to eq(400)
          expect(JSON.parse(last_response.body)).to eq({ "error" => "film[rolling_days] has an invalid day" })
        end
      end
    end
  end
  describe 'GET /films' do
    context 'when there is no week day' do
      it 'returns a 400 error with a proper message' do
        get '/api/v1/films'

        expect(JSON.parse(last_response.body)).to eq({ "error" => "day is missing, day is not valid" })
        expect(last_response.status).to eq(400)
      end
    end

    context 'when there is a week day' do
      it 'returns a list of movies playing that day' do
        harry_potter = FactoryBot.create(:film, :harry_potter, rolling_days: ['tuesday', 'monday'])
        back_to_the_future = FactoryBot.create(:film, :back_to_the_future, rolling_days: ['tuesday'])
        star_wars = FactoryBot.create(:film, :star_wars, rolling_days: ['saturday'])

        get 'api/v1/films', day: 'tueSday'

        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body))
          .to include(
            harry_potter.stringify_keys,
            back_to_the_future.stringify_keys
          )
        expect(JSON.parse(last_response.body)).not_to include(star_wars.stringify_keys)
      end
    end

    context 'when there is a wrong week day' do
      it 'returns a 400 error with a proper message' do
        get 'api/v1/films', day: 'Humpday'
        expect(last_response.status).to eq(400)
        expect(JSON.parse(last_response.body)).to eq({ "error" => "day is not valid" })
      end
    end
  end
end
