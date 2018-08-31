# Safettp
Make sure HTTP requests never fail.

## Synopsis
Safettp is an easy configurable HTTP library that encourages you to always cover what will happen after a request has been made.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'safettp'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install safettp

## Usage

### The client
To make use of the available functionality in Safettp, you will have to include the `Safettp::Client` module on a class of yours.
```ruby
class HTTPBinClient
  include Safettp::Client
end
```

Most often your HTTP client will be using the same set of options for every request. You can configure them like so:
```ruby
class HTTPBinClient
  include Safettp::Client

  configure do |config|
    config.base_url = 'https://httpbin.org'
    config.default_options = { headers: { Accept: 'application/json' } }
  end
end
```

From this point on your client is fit for fight!

### Performing a request
 A client will be able to perform `get`, `post`, `put`, `patch` and `delete` like so:
```ruby
HTTPBinClient.post('https://httpbin.org/post', options) do |result|
  result.on_success do |response|
    # Your code goes here upon success.
  end

  result.on_failure do |response|
    # Your code goes here upon failure.
  end
end
```

As you can see two separate blocks are yielded whether the request succeeded or failed. In order to use the method you will have to provide both. This will guard you from unexpected errors. Neat right?

The options hash provided as the second parameter in the example above can be used to append additional information to the request. _You can read about the available options [here](#request-options)_

### The response object
To retrieve the data obtained from the request you call `#parsed_body`. It will parse the data from JSON.
```ruby
result.on_success do |response|
  puts response.parsed_body
end
```

In case of a failed request, you can find additional information by calling `#http_response`. This will return a `Net::HTTPResponse` object which you can investigate further.

### Request options
#### Request body
A body can be set with the `:body` option. It will be parsed to JSON.
```ruby
HTTPBinClient.post('/post', body: { foo: 'bar' })
# ...
```

#### Query parameters
Query parameters can be set with the `:query` option.
```ruby
HTTPBinClient.get('/get', query: { foo: 'bar' })
```

#### Headers
Headers can be set with the `:headers` option.
```ruby
HTTPBinClient.get('/get', headers: { Accept: 'application/json' })
```

#### Authentication
Authentication can be set with the `:auth` option. As of now Safettp only supports basic authentication.
```ruby
HTTPBinClient.get('/get', auth: {
  type: :basic,
  username: 'username',
  password: 'password'
})
```

## Development
After checking out the repo, run `bundle install` to install dependencies. Then, run `rspec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/istanful/safettp.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

