require 'sequel'
require 'db/config'

module DB
  class Connection
    class << self
      def run(query)
        connection.run(query)
      end

      def config
        @config ||= DB::Config.new.config[:default]
      end

      def connection
        @connection ||= begin
          Sequel.extension :pg_array_ops

          connection = Sequel.connect(config[:url])
          connection.extension :pg_array
          connection
        end
      end
    end
  end

  class << self
    def create!
      db_name = Connection.config[:database]

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
        column :rolling_days, 'varchar[]', default: []
      end

      puts "Creating bookings table"
      Connection.connection.create_table :bookings do
        primary_key :id
        foreign_key :film_id
        Date :date
      end
    end

    def reset!
      Connection.connection.tables.each do |table|
        Connection.connection.drop_table(table)
      end

      migrate
    end
  end
end
