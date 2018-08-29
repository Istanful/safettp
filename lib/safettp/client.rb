class Safettp::Client
  class Configuration
    attr_accessor :base_url
    attr_accessor :default_options

    def initialize
      @default_options = {
        headers: Safettp::HTTPOptions::DEFAULT_HEADERS
      }
    end
  end

  attr_reader :base_url, :options_hash

  def initialize(base_url, options_hash = {})
    @base_url = base_url
    @options_hash = options_hash
  end

  def self.http_query_method(method)
    define_method(method) do
      |uri_suffix, query = {}, options = { query: query }, &block|
      perform(method, uri_suffix, options, &block)
    end

    define_singleton_method(method) do
      |uri_suffix, query = {}, options = { query: query }, &block|
      perform(method, uri_suffix, options, &block)
    end
  end

  def self.http_body_method(method)
    define_method(method) do
      |uri_suffix, body = {}, options = { body: body }, &block|
      perform(method, uri_suffix, options, &block)
    end

    define_singleton_method(method) do
      |uri_suffix, body = {}, options = { body: body }, &block|
      perform(method, uri_suffix, options, &block)
    end
  end

  %i[get delete].each do |method|
    http_query_method(method)
  end

  %i[post put patch].each do |method|
    http_body_method(method)
  end

  def perform(*args, &block)
    response = perform_without_guard(*args)
    guard = Safettp::Guard.new(response)
    yield(guard)
    guard.evaluate!
  end

  def perform_without_guard(method, uri_suffix = '/', options = {})
    url = "#{base_url}#{uri_suffix}"
    Safettp::Request.new(url, options_hash.merge(options))
                    .perform(method)
  end

  class << self
    attr_accessor :config

    def perform(*args, &block)
      response = perform_without_guard(*args)
      guard = Safettp::Guard.new(response)
      yield(guard)
      guard.evaluate!
    end

    def perform_without_guard(*args)
      new(config.base_url, config.default_options).perform_without_guard(*args)
    end
  end

  def self.configure
    self.config ||= Configuration.new
    yield(config)
  end
end
