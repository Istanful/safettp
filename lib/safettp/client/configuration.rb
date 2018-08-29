class Safettp::Client::Configuration
  attr_accessor :base_url
  attr_accessor :default_options

  def initialize
    @default_options = {
      headers: Safettp::HTTPOptions::DEFAULT_HEADERS
    }
  end
end
