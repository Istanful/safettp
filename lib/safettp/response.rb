class Safettp::Response
  attr_reader :http_response, :parser

  def initialize(http_response, parser = Safettp::Parsers::JSON)
    @http_response = http_response
    @parser = parser
  end

  def success?
    @http_response.kind_of? Net::HTTPSuccess
  end

  def failure?
    !success?
  end

  def parsed_body
    parser.decode(http_response.body)
  end
end
