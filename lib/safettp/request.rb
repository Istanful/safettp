class Safettp::Request
  attr_reader :uri

  def initialize(uri, options = {})
    @uri = URI(uri)
  end

  def perform(method)
    Safettp::Response.new(
      http.request(request_for(method))
    )
  end

  def self.request_for(verb, uri)
    klass = Kernel.const_get("Net::HTTP::#{verb.capitalize}")
    klass.new(uri)
  end

  private

  def http
    Net::HTTP.new(uri.host, uri.port)
  end

  def request_for(verb)
    self.class.request_for(verb, uri)
  end
end
