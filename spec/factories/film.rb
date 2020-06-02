FactoryBot.define do
  to_create { |instance| instance.save }

  factory :film do
    trait :harry_potter do
      name { Faker::Movies::HarryPotter.book }
      description { Faker::Movies::HarryPotter.quote }
      image_url { Faker::Internet.url }
      rolling_days { ['tuesday'] }
    end

    trait :back_to_the_future do
      name { 'Back To The Future' }
      description { Faker::Movies::BackToTheFuture.quote }
      image_url { Faker::Internet.url }
      rolling_days { ['monday'] }
    end

    trait :star_wars do
      name { 'The Return of the Jedi' }
      description { Faker::Movies::StarWars.quote }
      image_url { Faker::Internet.url }
      rolling_days { ['Saturday'] }
    end
  end
end
