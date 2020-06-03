FactoryBot.define do
  factory :booking do
    date { '2020-10-05' }

    trait :with_film_on_date do
      before(:create) do |_, object|
        object.film = create(:film, rolling_days: [object.date.strftime('%A')])
      end
    end
  end
end
