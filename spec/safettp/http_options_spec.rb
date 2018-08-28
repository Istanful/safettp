require 'spec_helper'

RSpec.describe Safettp::HTTPOptions do
  describe '#headers' do
    context 'when headers are present in options hash' do
      it 'returns the headers specified ' do
        headers = { Accept: 'application/json' }
        options = described_class.new(headers: headers)

        expect(options.headers).to eq(headers)
      end
    end

    context 'when headers are not present in options hash' do
      it 'returns the default headers' do
        options = described_class.new

        expect(options.headers).to eq(described_class::DEFAULT_HEADERS)
      end
    end
  end

  describe '#body' do
    context 'when body is present in options hash' do
      it 'returns the body specified ' do
        body = '\{"foo":"bar"\}'
        options = described_class.new(body: body)

        expect(options.body).to eq(body)
      end
    end

    context 'when body is not present in options hash' do
      it 'an empty string' do
        options = described_class.new

        expect(options.body).to eq('')
      end
    end
  end

  describe '#parser' do
    context 'when parser is specified in options hash' do
      it 'returns the parser specified ' do
        parser = double('Parser')
        options = described_class.new(parser: parser)

        expect(options.parser).to eq(parser)
      end
    end

    context 'when parser is not present in options hash' do
      it 'returns the json parser' do
        options = described_class.new

        expect(options.parser).to eq(Safettp::Parsers::JSON)
      end
    end
  end
end
