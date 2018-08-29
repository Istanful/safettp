require 'spec_helper'

RSpec.describe Safettp::Response do
  describe '#parsed_body' do
    it 'parses the body as JSON' do
      hash = { 'foo' => 'bar' }
      stubbed_response = double(Net::HTTPOK, body: JSON.generate(hash))

      response = described_class.new(stubbed_response)

      expect(response.parsed_body).to eq(hash)
    end

    describe '#success?' do
      it 'returns true if the response is of kind Net::HTTPSuccess' do
        stubbed_response = double(Net::HTTPSuccess)
        allow(stubbed_response).to receive(:kind_of?).and_return(true)

        response = described_class.new(stubbed_response)

        expect(response).to be_success
      end

      it 'returns false if the response is not of kind Net::HTTPSuccess' do
        stubbed_response = double(Net::HTTPClientError)

        response = described_class.new(stubbed_response)

        expect(response).to_not be_success
      end
    end

    describe '#failure?' do
      it 'returns true if the response is not successful' do
        stubbed_response = double(Net::HTTPClientError)
        response = described_class.new(stubbed_response)
        allow(response).to receive(:success?).and_return(false)

        expect(response).to be_failure
      end

      it 'returns false if the response is successful' do
        stubbed_response = double(Net::HTTPSuccess)
        response = described_class.new(stubbed_response)
        allow(response).to receive(:success?).and_return(true)

        expect(response).to_not be_failure
      end
    end
  end
end
