class AddPostgresExtensions < ActiveRecord::Migration[8.0]
  enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
  enable_extension 'pg_stat_statements' unless extension_enabled?('pg_stat_statements')
  enable_extension 'uuid-ossp' unless extension_enabled?('uuid-ossp')
  enable_extension 'unaccent' unless extension_enabled?('unaccent')
  enable_extension 'plpgsql' unless extension_enabled?('plpgsql')
end
