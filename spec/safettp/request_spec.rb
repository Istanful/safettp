require 'spec_helper'

RSpec.describe Safettp::Request do
  describe '.http_request_for' do
    it 'returns the appropriate net http instance' do
      uri = URI('http://example.com')

      expect(request_for(:get, uri)).to be_an_instance_of(Net::HTTP::Get)
      expect(request_for(:post, uri)).to be_an_instance_of(Net::HTTP::Post)
      expect(request_for(:put, uri)).to be_an_instance_of(Net::HTTP::Put)
      expect(request_for(:patch, uri)).to be_an_instance_of(Net::HTTP::Patch)
      expect(request_for(:delete, uri)).to be_an_instance_of(Net::HTTP::Delete)
    end

    def request_for(verb, uri)
      Safettp::Request.request_for(verb, uri)
    end
  end

  describe '#perform' do
    it 'sets up a net http request object with the given url' do
      stub_http
      uri = URI('https://example.com')
      request = described_class.new(uri)
      net_req = double(Net::HTTP::Get).as_null_object
      allow(net_req).to receive(:new).with(uri)
      allow(Safettp::Request).to receive(:request_for).and_return(net_req)

      request.perform(:get)

      expect(Safettp::Request).to have_received(:request_for).with(:get, uri)
    end

    it 'performs an http request' do
      uri = URI('https://example.com')
      stubbed_http = stub_http
      allow(stubbed_http).to receive(:reqest)
      request = described_class.new(uri)

      request.perform(:get)

      expect(Net::HTTP).to have_received(:new).with('example.com', 443)
      expect(stubbed_http).to have_received(:request)
        .with(an_instance_of(Net::HTTP::Get))
    end

    it 'wraps the result as a Safettp::Response' do
      stubbed_response = double(Net::HTTPOK)
      stub_http(request: stubbed_response)
      allow(Safettp::Response).to receive(:new)
      request = described_class.new('https://example.com')

      request.perform(:get)

      expect(Safettp::Response).to have_received(:new).with(stubbed_response)
    end

    def stub_http(stubbed_methods = {})
      double(Net::HTTP).as_null_object.tap do |stub|
        allow(Net::HTTP).to receive(:new).and_return(stub)
        stubbed_methods.each do |method, return_val|
          allow(stub).to receive(method).with(any_args).and_return(return_val)
        end
      end
    end
  end
end
