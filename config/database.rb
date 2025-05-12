# frozen_string_literal: true

require 'dotenv/load'
Dotenv.load

module Database
  class << self
    def fetch_config
      database = case ENV.fetch('RACK_ENV', 'development')
                 when 'development'
                   ENV.fetch('DB_DEVELOPMENT')
                 when 'test'
                   ENV.fetch('DB_TEST')
                 else
                   ENV.fetch('DB_PRODUCTION')
                 end

      base_config.merge!(database: database)
    end

    private

    def base_config
      {
        adapter: 'postgresql',
        encoding: 'unicode',
        username: ENV.fetch('DB_USER'),
        password: ENV.fetch('DB_PASSWORD'),
        host: ENV.fetch('DB_HOST'),
        port: ENV.fetch('DB_PORT'),
        pool: ENV.fetch('DB_POOL_SIZE'),
        timeout: ENV.fetch('DB_TIMEOUT'),
        env_name: ENV.fetch('RACK_ENV')
      }
    end
  end
end
