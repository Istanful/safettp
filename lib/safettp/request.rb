class Safettp::Request
  attr_reader :uri, :options

  def initialize(uri, options = {})
    @uri = URI(uri)
    @options = Safettp::HTTPOptions.new(options)
    @uri.query = @options.query
  end

  def perform(method)
    net = Safettp::Request::Net.new(method, uri, options)
    Safettp::Response.new(net.perform, options.parser)
  end
end
