module Safettp::Client
  attr_reader :base_url, :options_hash

  def initialize(base_url = self.class.config.base_url,
                 options_hash = self.class.config.default_options)
    @base_url = base_url
    @options_hash = options_hash
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

  module ClassMethods
    attr_accessor :config

    def instance_from_default_options
      new(config.base_url, config.default_options)
    end

    def method_missing(method, *args, &block)
      return super unless respond_to_missing?(method, *args, &block)
      instance_from_default_options.public_send(method, *args, &block)
    end

    def respond_to_missing?(method, *args, &block)
      instance_from_default_options.respond_to?(method)
    end

    def configure
      self.config ||= Safettp::Client::Configuration.new
      yield(config)
    end
  end

  def self.included(base)
    base.extend(ClassMethods)

    %i[get post put patch delete].each do |method|
      define_method(method) do |uri_suffix, options, &block|
        perform(method, uri_suffix, options, &block)
      end
    end
  end
end
