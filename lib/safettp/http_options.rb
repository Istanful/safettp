class Safettp::HTTPOptions
  AUTHENTICATORS = {
    none: Safettp::NoneAuthenticator,
    basic: Safettp::BasicAuthenticator
  }.freeze

  DEFAULT_HEADERS = {
    Accept: 'application/json',
    'Content-Type': 'application/json'
  }.freeze

  attr_reader :options_hash

  def initialize(options_hash = {})
    @options_hash = options_hash
  end

  def headers
    options_hash.fetch(:headers, DEFAULT_HEADERS)
  end

  def parser
    options_hash.fetch(:parser, Safettp::Parsers::JSON)
  end

  def query
    URI.encode_www_form(options_hash.fetch(:query, {}))
  end

  def body
    options_hash.fetch(:body, "")
  end

  def authorization
    authorization_options = options_hash.fetch(:authorization, { type: :none })
    AUTHENTICATORS.fetch(authorization_options[:type], Safettp::NoneAuthenticator)
                  .new(authorization_options)
  end
end
