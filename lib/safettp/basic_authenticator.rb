class Safettp::BasicAuthenticator
  attr_reader :options

  def initialize(options)
    @options = options
  end

  def set(request)
    request.basic_auth(options[:username], options[:password])
  end
end
