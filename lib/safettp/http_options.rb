class Safettp::HTTPOptions
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

  def body
    options_hash.fetch(:body, "")
  end
end
