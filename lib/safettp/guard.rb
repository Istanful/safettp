class Safettp::Guard
  class Safettp::Guard::StatesNotCovered < Safettp::Error
  end

  attr_reader :covered, :response

  def initialize(response)
    @response = response
    @covered = []
  end

  def evaluate!
    return response if safe?
    raise Safettp::Guard::StatesNotCovered
  end

  def cover(state, &block)
    @covered << state
		yield(response) if response_is?(state)
  end

  def safe?
    covered.include?(:success) &&
      covered.include?(:failure)
  end

  def on_success(&block)
    cover(:success, &block)
  end

  def on_failure(&block)
    cover(:failure, &block)
  end

	private

	def response_is?(state)
		response.public_send("#{state}?")
	end
end
