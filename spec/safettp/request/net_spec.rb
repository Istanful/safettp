require 'spec_helper'

RSpec.describe Safettp::Request::Net do
  describe '#request' do
    it 'constructs the net request object from the given options' do
      uri = URI('http://example.com')
      body = { baz: 'qux' }
      stubbed_parser = double('Parser', encode: 'encoded_body')
      options = Safettp::HTTPOptions.new(
        headers: { Accept: 'application/json' },
        body: { baz: 'qux' },
        parser: stubbed_parser,
        authorization: {
          type: :basic,
          username: 'foo',
          password: 'bar'
        }
      )
      net = described_class.new(:post, uri, options)

      result = net.request

      expect(result).to be_an_instance_of(Net::HTTP::Post)
      expect(result.uri).to eq(uri)
      expect(result.get_fields('Accept')).to include('application/json')
      expect(result.get_fields('Authorization')).to include('Basic Zm9vOmJhcg==')
      expect(result.body).to eq('encoded_body')
    end
  end

  describe '#http' do
    it 'constructs an Net::HTTP instance' do
      uri = URI('https://example.com')
      net = described_class.new(:post, uri, {})

      result = net.http

      expect(result).to be_an_instance_of(Net::HTTP)
    end

    context 'when uri scheme is https' do
      it 'uses https' do
        uri = URI('https://example.com')
        net = described_class.new(:post, uri, {})

        result = net.http

        expect(result).to be_an_instance_of(Net::HTTP)
        expect(result.use_ssl?).to eq(true)
        expect(result.verify_mode).to eq(OpenSSL::SSL::VERIFY_PEER)
      end
    end

    context 'when uri scheme is http' do
      it 'uses https' do
        uri = URI('http://example.com')
        net = described_class.new(:post, uri, {})

        result = net.http

        expect(result).to be_an_instance_of(Net::HTTP)
        expect(result.use_ssl?).to eq(false)
        expect(result.verify_mode).to eq(OpenSSL::SSL::VERIFY_PEER)
      end
    end
  end
end
