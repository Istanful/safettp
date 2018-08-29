require 'spec_helper'


RSpec.describe Safettp::Guard do
  describe '#evaluate!' do
    context 'when the guard is not safe' do
      it 'raises an error' do
        guard = described_class.new(stubbed_response)
        allow(guard).to receive(:safe?).and_return(false)

        evaluation = -> { guard.evaluate! }

        expect(evaluation).to raise_error(Safettp::Guard::StatesNotCovered)
      end
    end

    context 'when the guard is safe' do
      it 'returns the response' do
        response = stubbed_response
        guard = described_class.new(response)
        allow(guard).to receive(:safe?).and_return(true)

        result = guard.evaluate!

        expect(result).to eq(response)
      end
    end
  end

  describe '#on_success' do
    it 'covers the success state' do
      response = stubbed_response(success: true)
      guard = described_class.new(response)
      allow(guard).to receive(:cover).and_call_original

      guard.on_success {}

      expect(guard).to have_received(:cover).with(:success)
    end
  end

  describe '#on_failure' do
    it 'covers the failure state' do
      response = stubbed_response(success: false)
      guard = described_class.new(response)
      allow(guard).to receive(:cover).and_call_original

      guard.on_failure {}

      expect(guard).to have_received(:cover).with(:failure)
    end
  end

  describe '#cover' do
    context 'when block is yielded' do
			context 'when request have the given state' do
        it 'yields the result to the block' do
					response = stubbed_response(success: true)
          guard = described_class.new(response)

          expect { |b| guard.cover(:success, &b) }.to yield_with_args(response)
        end
			end

			context 'when request does not have state' do
				it 'does not yield the block' do
					response = stubbed_response(success: false)
					guard = described_class.new(response)

					expect { |b| guard.cover(:success, &b) }.to_not yield_with_args(response)
				end
			end
    end
  end

  describe '#guarded?' do
    context 'when success and failure states given' do
      it 'returns true' do
        response = stubbed_response
        guard = described_class.new(response)
        guard.on_success {}
        guard.on_failure {}

        expect(guard).to be_safe
      end
    end

    context 'when only success state given' do
      it 'returns false' do
        response = stubbed_response
        guard = described_class.new(response)
        guard.on_success {}

        expect(guard).to_not be_safe
      end
    end

    context 'when only failure state given' do
      it 'returns false' do
        response = stubbed_response
        guard = described_class.new(response)
        guard.on_failure {}

        expect(guard).to_not be_safe
      end
    end
  end

  def stubbed_response(success: true)
    double(Safettp::Response, success?: success, failure?: !success)
  end
end
