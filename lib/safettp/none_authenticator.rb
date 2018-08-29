class Safettp::NoneAuthenticator
  attr_reader :options

  def initialize(options)
    @options = options
  end

  def set(request)
    request
  end
end
