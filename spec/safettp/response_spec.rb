require 'spec_helper'

RSpec.describe Safettp::Response do
  describe '#parsed_body' do
    it 'parses the body as JSON' do
      hash = { 'foo' => 'bar' }
      stubbed_response = double(Net::HTTPOK, body: JSON.generate(hash))

      response = described_class.new(stubbed_response)

      expect(response.parsed_body).to eq(hash)
    end
  end
end
