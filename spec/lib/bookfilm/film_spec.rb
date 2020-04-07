require 'spec_helper'

describe Bookfilm::Film do
  describe '::create' do
    it 'creates a new film' do
      params = {
        name: 'The Terminator',
        description: 'The Terminator is a 1984 American science fiction film directed by James Cameron. It stars Arnold Schwarzenegger as the Terminator, a cyborg assassin sent back in time from 2029 to 1984 to kill Sarah Connor (Linda Hamilton), whose son will one day become a savior against machines in a post-apocalyptic future. Michael Biehn plays Kyle Reese, a reverent soldier sent back in time to protect Sarah',
        image_url: 'https://en.wikipedia.org/wiki/The_Terminator#/media/File:Terminator1984movieposter.jpg',
        rolling_days: ['monday', 'saturday']
      }

      expect(DB::Connection).to receive_message_chain(:connection, :[], :insert).with(params)
      described_class.create(params)
    end
  end
end
