require 'grape'

class Routing < Grape::API
  format :json
  prefix :api

  namespace :v1 do
    resource :films do
      get do
        "All films here"
      end
    end
  end
end
