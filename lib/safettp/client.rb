class Safettp::Client
  attr_reader :base_url, :options_hash

  def initialize(base_url, options_hash = {})
    @base_url = base_url
    @options_hash = options_hash
  end

  def get(uri_suffix, query, options = { query: query }, &block)
    perform(:get, uri_suffix, options, &block)
  end

  def post(uri_suffix, body, options = { body: body }, &block)
    perform(:post, uri_suffix, options, &block)
  end

  def put(uri_suffix, body, options = { body: body }, &block)
    perform(:put, uri_suffix, options, &block)
  end

  def patch(uri_suffix, body, options = { body: body }, &block)
    perform(:patch, uri_suffix, options, &block)
  end

  def delete(uri_suffix, query, options = { query: query }, &block)
    perform(:delete, uri_suffix, options, &block)
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
end
