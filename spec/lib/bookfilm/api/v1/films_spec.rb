require 'spec_helper'

describe 'Films endpoint' do
  describe 'POST /film' do
    context 'when the params are valid' do
      it 'returns a 201 status with message' do
        params = {
          film: {
            name: 'The Terminator',
            description: 'The Terminator is a 1984 American science fiction film directed by James Cameron. It stars Arnold Schwarzenegger as the Terminator, a cyborg assassin sent back in time from 2029 to 1984 to kill Sarah Connor (Linda Hamilton), whose son will one day become a savior against machines in a post-apocalyptic future. Michael Biehn plays Kyle Reese, a reverent soldier sent back in time to protect Sarah',
            image_url: 'https://en.wikipedia.org/wiki/The_Terminator#/media/File:Terminator1984movieposter.jpg',
            rolling_days: ['monday', 'saturday']
          }
        }

        post '/api/v1/films', params
        expect(last_response.status).to eq(201)

        params = params[:film]
        expect(JSON.parse(last_response.body))
          .to include({
              id: 1,
              name: params[:name],
              description: params[:description],
              image_url: params[:image_url],
              rolling_days: "(monday,saturday)"
            }.stringify_keys)
      end
    end

    context 'when there is a missing param' do
      it 'returns a 400 status' do
        params = {
          film: {
            name: nil,
            description: nil,
            image_url: nil
          }
        }

        post '/api/v1/films', params
        expect(last_response.status).to eq(400)
      end
    end

    context 'when there is an invalid param' do
      it 'returns a 422 status with message' do
        params = {
          film: {
            name: nil,
            description: 'The Terminator is a 1984 American science fiction film directed by James Cameron. It stars Arnold Schwarzenegger as the Terminator, a cyborg assassin sent back in time from 2029 to 1984 to kill Sarah Connor (Linda Hamilton), whose son will one day become a savior against machines in a post-apocalyptic future. Michael Biehn plays Kyle Reese, a reverent soldier sent back in time to protect Sarah',
            image_url: 'https://en.wikipedia.org/wiki/The_Terminator#/media/File:Terminator1984movieposter.jpg',
            rolling_days: ['monday', 'saturday']
          }
        }

        post '/api/v1/films', params

        expect(last_response.status).to eq(422)
        expect(JSON.parse(last_response.body)).to eq({ "errors" => ['name is blank'] })
      end
    end
  end
end
