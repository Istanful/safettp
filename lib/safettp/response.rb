class Safettp::Response
  attr_reader :http_response

  def initialize(http_response)
    @http_response = http_response
  end
end