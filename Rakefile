require 'yaml'
require 'sequel'

namespace :db do
  task :create do
    db_config = YAML.load(File.open('db/config.yml'))
    db_name = db_config['default']['database']
    connect_params = db_config['default'].merge('database' => 'postgres')

    Sequel.connect(connect_params) do |db|
      db.execute "DROP DATABASE IF EXISTS #{db_name}"
      db.execute "CREATE DATABASE #{db_name}"

      puts "DB #{db_name} created!"
    end
  end
end
