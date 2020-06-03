module DB
  class Config
    attr_reader :config

    def initialize
      @config = {
        default: {
          adapter: 'postgres',
          url: ENV.fetch('DATABASE_URL', 'postgres://localhost/bookfilm'),
          encoding: 'unicode',
          database: 'bookfilm',
        }
      }
    end
  end
end
