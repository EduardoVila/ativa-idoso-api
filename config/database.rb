# frozen_string_literal: true

require 'dotenv/load'
Dotenv.load

module Database
  class << self
    def fetch_config
      database = case EnvHelper.fetch('RACK_ENV', 'development')
                 when 'development'
                   EnvHelper.fetch('DB_DEVELOPMENT')
                 when 'test'
                   EnvHelper.fetch('DB_TEST')
                 else
                   EnvHelper.fetch('DB_PRODUCTION')
                 end

      base_config.merge!(database: database)
    end

    private

    def base_config
      {
        adapter: 'postgresql',
        encoding: 'unicode',
        username: EnvHelper.fetch('DB_USER'),
        password: EnvHelper.fetch('DB_PASSWORD'),
        host: EnvHelper.fetch('DB_HOST'),
        port: EnvHelper.fetch('DB_PORT'),
        pool: EnvHelper.fetch('DB_POOL_SIZE'),
        timeout: EnvHelper.fetch('DB_TIMEOUT'),
        env_name: EnvHelper.fetch('RACK_ENV')
      }
    end
  end
end
