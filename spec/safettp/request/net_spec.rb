require 'spec_helper'

RSpec.describe Safettp::Request::Net do
  describe '#construct' do
    it 'constructs the net request object from the given options' do
      uri = URI('http://example.com')
      body = { baz: 'qux' }
      stubbed_parser = double('Parser', encode: 'encoded_body')
      options = double(Safettp::HTTPOptions,
        headers: { Accept: 'application/json' },
        body: { baz: 'qux' },
        parser: stubbed_parser
      )
      request = described_class.new(:post, uri, options)

      result = request.request

      expect(result).to be_an_instance_of(Net::HTTP::Post)
      expect(result.uri).to eq(uri)
      expect(result.get_fields('Accept')).to include('application/json')
      expect(result.body).to eq('encoded_body')
    end
  end
end
