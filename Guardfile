# frozen_string_literal: true

# Guardfile
guard :rspec, cmd: 'bundle exec rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^app/(.+)\.rb$}) { |m| "spec/app/#{m[1]}_spec.rb" }
  watch(%r{^models/concerns/(.+)\.rb$}) do |m|
    "spec/models/concerns/#{m[1]}_spec.rb"
  end
end
