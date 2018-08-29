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
      obj.use_ssl = uri.scheme == 'https'
      obj.verify_mode = OpenSSL::SSL::VERIFY_PEER
    end
  end

  def request
    klass = Kernel.const_get("Net::HTTP::#{verb.capitalize}")
    klass.new(uri).tap do |request|
      set_headers(request)
      set_body(request)
      set_authorization(request)
    end
  end

  private

  def set_authorization(request)
    options.authorization.set(request)
  end

  def set_body(request)
    request.body = options.parser.encode(options.body)
  end

  def set_headers(request)
    options.headers.each do |header, value|
      request.add_field(header.to_s, value)
    end
  end
end
