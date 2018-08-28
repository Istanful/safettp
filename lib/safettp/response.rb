class Safettp::Response
  attr_reader :http_response, :parser

  def initialize(http_response, parser = Safettp::Parsers::JSON)
    @http_response = http_response
    @parser = parser
  end

  def parsed_body
    puts http_response.body
    parser.decode(http_response.body)
  end
end
