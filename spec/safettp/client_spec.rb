require 'spec_helper'

RSpec.describe Safettp::Client do
  let(:client_class) do
    Class.new do
      include Safettp::Client

      configure do |config|
        config.base_url = 'https://example.com'
      end
    end
  end

  describe '#perform' do
    it 'wraps the response in a guard' do
      client = client_class.new('https://example.com')
      response = double(Safettp::Response)
      stubbed_request = stub_safettp_request(response)
      guard = double(Safettp::Guard)
      allow(guard).to receive(:evaluate!).and_return(response)
      allow(Safettp::Guard).to receive(:new).and_return(guard)

      expect { |b| client.perform(:post, 'post', &b) }.to yield_with_args(guard)
      expect(guard).to have_received(:evaluate!)
    end
  end

  describe '#perform_without_guard' do
    it 'performs an http request with the appropriate method' do
      client = client_class.new('https://example.com')
      stubbed_request = stub_safettp_request

      client.perform_without_guard(:post, '/post')

      expect(Safettp::Request).to have_received(:new)
        .with('https://example.com/post', any_args)
      expect(stubbed_request).to have_received(:perform).with(:post)
    end

    it 'passes along the options' do
      options = { headers: { Accept: 'application/json' } }
      additional_options = { query: { foo: 'bar' } }
      client = client_class.new('https://example.com', options)
      stub_safettp_request

      client.perform_without_guard(:get, '/', additional_options)

      expect(Safettp::Request).to have_received(:new)
        .with('https://example.com/', options.merge(additional_options))
    end
  end

  def stub_safettp_request(response = double(Safettp::Response))
    double(Safettp::Request).tap do |req|
      allow(req).to receive(:perform).and_return(response)
      allow(Safettp::Request).to receive(:new).and_return(req)
    end
  end
end
