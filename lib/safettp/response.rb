class Safettp::Response
  attr_reader :http_response, :parser

  def initialize(http_response, parser = JSON)
    @http_response = http_response
    @parser = parser
  end

  def parsed_body
    parser.parse(http_response.body)
  end
end
