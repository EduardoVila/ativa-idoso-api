# frozen_string_literal: true

require 'rack/test'
require 'rspec'
require_relative '../../app/middleware/idempotency'

RSpec.describe Idempotency do
  include Rack::Test::Methods

  let(:app) do
    Rack::Builder.new do
      use described_class
      run ->(_) { [200, {}, ['OK']] }
    end
  end

  describe 'POST requests' do
    context 'without Idempotency-Key' do
      it 'returns 400' do
        post '/'
        expect(last_response.status).to eq(400)
        expect(last_response.body).to include('Missing Idempotency-Key header')
      end
    end

    context 'with invalid Idempotency-Key' do
      it 'returns 400' do
        header 'Idempotency-Key', 'invalid-key-format'
        post '/'
        expect(last_response.status).to eq(400)
        expect(last_response.body).to include('Invalid Idempotency-Key format')
      end
    end

    context 'with valid Idempotency-Key' do
      let(:valid_key) { '123e4567-e89b-12d3-a456-426614174000' }

      it 'passes the request to the next component' do
        header 'Idempotency-Key', valid_key
        post '/'
        expect(last_response.status).to eq(200)
        expect(last_response.body).to eq('OK')
      end
    end
  end
end
