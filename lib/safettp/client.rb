class Safettp::Client
  attr_reader :base_url, :options_hash

  def initialize(base_url, options_hash = {})
    @base_url = base_url
    @options_hash = options_hash
  end

  def perform_without_guard(method, uri_suffix = '/')
    url = "#{base_url}#{uri_suffix}"
    Safettp::Request.new(url, options_hash)
                    .perform(method)
  end
end
