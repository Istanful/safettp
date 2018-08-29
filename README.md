# Safettp

Safettp is another HTTP library. It encourages your requests to always handle
the failure state, and does so in a straightforward and easy way.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'safettp'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install safettp

## Synopsis
```ruby
class MyHttpClient
  include Safettp::Client

  configure do |config|
    config.base_url = 'https://httpbin.org'
    config.default_options = { headers: { Accept: 'application/json' } }
  end

  def do_post(payload, &block)
    post('/post', payload, &block)
  end
end

MyHttpClient.do_post({ body: 'my_body' }) do |result|
  result.on_success do |response|
    puts response.parsed_body
  end

  result.on_failure do |response|
    puts 'Request failed :c'
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/safettp.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

