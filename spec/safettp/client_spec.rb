require 'spec_helper'

RSpec.describe Safettp::Client do
  describe '#perform_without_guard' do
    it 'performs an http request with the appropriate method' do
      client = described_class.new('https://example.com')
      stubbed_request = stub_safettp_request

      client.perform_without_guard(:post, '/post')

      expect(Safettp::Request).to have_received(:new)
        .with('https://example.com/post', any_args)
      expect(stubbed_request).to have_received(:perform).with(:post)
    end

    it 'passes along the options' do
      options = { headers: { Accept: 'application/json' } }
      client = described_class.new('https://example.com', options)
      stub_safettp_request

      client.perform_without_guard(:get)

      expect(Safettp::Request).to have_received(:new)
        .with('https://example.com/', options)
    end
  end

  def stub_safettp_request
    double(Safettp::Request).tap do |req|
      allow(req).to receive(:perform)
      allow(Safettp::Request).to receive(:new).and_return(req)
    end
  end
end
