module DB
  class Config
    attr_reader :config

    def initialize
      @config = {
        default: {
          adapter: 'postgres',
          url: ENV['DATABASE_URL'],
          encoding: 'unicode',
          database: 'bookfilm',
        }
      }
    end
  end
end
