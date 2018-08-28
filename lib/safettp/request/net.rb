class Safettp::Request::Net
  attr_reader :verb, :uri, :options

  def initialize(verb, uri, options)
    @verb = verb
    @uri = uri
    @options = options
  end

  def perform
    http.request(request)
  end

  def http
    ::Net::HTTP.new(uri.host, uri.port).tap do |obj|
      obj.use_ssl = true
      obj.verify_mode = OpenSSL::SSL::VERIFY_PEER
    end
  end

  def request
    klass = Kernel.const_get("Net::HTTP::#{verb.capitalize}")
    klass.new(uri).tap do |request|
      options.headers.each do |header, value|
        request.add_field(header.to_s, value)
      end

      request.body = options.parser.encode(options.body)
    end
  end
end
