# Bookfilm

A simplistic API that allows you to query and book movie tickets for our local theater. Visit us at http://bookfilm.herokuapp.com by using our API only.

## Development
### Stack
 * Rack
 * Sequel
 * Grape
 * Heroku

To run this project locally:

1. Install dependencies `$ bundle install`
2. Create and migrate the DB with Sequel `rake db:reset`
3. Start the server `$ rackup` (the server will run on `localhost:9292` you can define a different port with the `-p` option)
4. You are done! Now you can make local calls to the API

_NOTE:_ In case you want to play around with the console, run `$ ./bin/console`. Also, you can run the specs using `rspec`.

## Endpoints
API root: **/api/v1/**

### Films
This endpoint will give you all the information you need about movies

#### GET / films
List all films playing on a specific weekday.

*METHOD:* `GET`
*PATH:* `/api/v1/films`

*PARAMS:*
* day (e.g. Monday, Saturday, Tuesday, etc)

##### Example
    # request
    curl --header "Content-Type: application/json" \
      --request GET 'http://bookfilm.herokuapp.com/api/v1/films?day=saturday'

    # response
    [
      {
          "id": 1,
          "name": "The Terminator",
          "description": "The Terminator is a 1984 American science fiction film directed by James Cameron. It stars Arnold Schwarzenegger as the Terminator, a cyborg assassin sent back in time from 2029 to 1984 to kill Sarah Connor (Linda Hamilton), whose son will one day become a savior against machines in a post-apocalyptic future. Michael Biehn plays Kyle Reese, a reverent soldier sent back in time to protect Sarah",
          "image_url": "https://en.wikipedia.org/wiki/The_Terminator#/media/File:Terminator1984movieposter.jpg",
          "rolling_days": [
              "saturday"
          ]
      },
      {
          "id": 3,
          "name": "Back to the Future",
          "description": "Marty travels back in time using an eccentric scientist's time machine. However, he must make his high-school-aged parents fall in love in order to return to the present.",
          "image_url": "https://upload.wikimedia.org/wikipedia/en/d/d2/Back_to_the_Future.jpg",
          "rolling_days": [
              "saturday"
          ]
      }
    ]

#### POST / films
Create a film.

*METHOD:* `POST`
*PATH:* `/api/v1/films`

*PARAMS:*
* film
  * name
  * description
  * image_url
  * rolling_days

##### Example
    # request
    curl --header "Content-Type: application/json" \
      --request POST 'http://bookfilm.herokuapp.com/api/v1/films' \
      --data-raw '{
      	"film": {
      		"name": "Back to the Future",
      		"description": "Marty travels back in time using an eccentric scientist'\''s time machine. However, he must make his high-school-aged parents fall in love in order to return to the present.",
      		"image_url": "https://upload.wikimedia.org/wikipedia/en/d/d2/Back_to_the_Future.jpg",
      		"rolling_days": ["saturday", "monday"]
      	}
      }'

    # response
    {
      "id": 4,
      "name": "Back to the Future",
      "description": "Marty travels back in time using an eccentric scientist's time machine. However, he must make his high-school-aged parents fall in love in order to return to the present.",
      "image_url": "https://upload.wikimedia.org/wikipedia/en/d/d2/Back_to_the_Future.jpg",
      "rolling_days": [
          "saturday"
      ]
    }

### Bookings
This endpoint will give you all the information related to bookings.

#### GET / bookings
Get all the bookings made given a range of time.

*METHOD:* `GET`
*PATH:* `/api/v1/bookings`

*PARAMS:*
* start_date
* end_date

##### Example
    # request
    curl --header "Content-Type: application/json" \
      --request GET 'http://bookfilm.herokuapp.com/api/v1/bookings?start_date=2020-01-10&end_date=2020-12-10'

    # response
    [
      {
        "id": 1,
        "film_id": 1,
        "date": "2020-01-15"
      },
      {
        "id": 2,
        "film_id": 1,
        "date": "2020-02-15"
      },
      {
        "id": 3,
        "film_id": 1,
        "date": "2020-05-15"
      },
      {
        "id": 4,
        "film_id": 1,
        "date": "2020-10-15"
      }
    ]

#### POST / bookings
Create a new booking for a movie on a date. Keep in mind that the theater fills up quickly, only 10 bookings are allowed for a movie per day. Also, make sure that the date you enter corresponds with the day the movie is playing.

*METHOD:* `POST`
*PATH:* `/api/v1/bookings`

*PARAMS:*
* booking
  * date
  * film_id

##### Example
    # request
    curl --header "Content-Type: application/json" \
      --request POST 'http://bookfilm.herokuapp.com/api/v1/bookings' \
      --data '{
        "booking": {
          "date": "2020-06-06",
          "film_id": 3
        }
      }'

    # response
    {
      "id": 11,
      "film_id": 3,
      "date": "2020-06-06"
    }
