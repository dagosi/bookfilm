require 'sequel'
require 'yaml'

module DB
  class << self
    def create!
      db_name = Connection.config['database']

      Sequel.connect(Connection.config) do |db|
        db.execute "DROP DATABASE IF EXISTS #{db_name}"
        db.execute "CREATE DATABASE #{db_name}"

        puts "DB #{db_name} created!"
      end
    end
  end

  class Connection
    class << self
      def run(query)
        connection.run(query)
      end

      def config
        @config ||= YAML.load(File.open('db/config.yml'))['default']
      end

      private

      def connection
        Sequel.connect(config)
      end
    end
  end
end
