require 'sequel'
require 'yaml'

module DB
  class Connection
    class << self
      def run(query)
        connection.run(query)
      end

      def config
        @config ||= YAML.load(File.open('db/config.yml'))['default']
      end

      def connection
        @connection ||= Sequel.connect(config)
      end
    end
  end

  class << self
    def create!
      db_name = Connection.config['database']

      Connection.connection do |db|
        db.execute "DROP DATABASE IF EXISTS #{db_name}"
        db.execute "CREATE DATABASE #{db_name}"

        puts "DB #{db_name} created!"
      end
    end

    def migrate
      puts "Creating films table"
      Connection.connection.create_table :films do
        primary_key :id
        String :name
        String :description
        String :image_url
        Array :rolling_days
      end

      puts "Creating bookings table"
      Connection.connection.create_table :bookings do
        primary_key :id
        foreign_key :film_id
        Date :date
      end
    end

    def reset!
      Connection.connection.drop_table(:films)
      Connection.connection.drop_table(:bookings)
      migrate
    end
  end
end
