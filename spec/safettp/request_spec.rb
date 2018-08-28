require 'spec_helper'

RSpec.describe Safettp::Request do
  describe '#perform' do
    it 'sets up a net http request object with the given options' do
      uri = URI('https://example.com')
      options = double(Safettp::HTTPOptions).as_null_object
      allow(Safettp::HTTPOptions).to receive(:new).and_return(options)
      stubbed_req = double(Safettp::Request::Net, perform: nil)
      allow(Safettp::Request::Net).to receive(:new).and_return(stubbed_req)
      request = described_class.new(uri)

      request.perform(:get)

      expect(Safettp::Request::Net).to have_received(:new)
        .with(:get, uri, options)
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

      expect(Safettp::Response).to have_received(:new)
        .with(stubbed_response, any_args)
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
