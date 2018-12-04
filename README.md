
# PolyAnalyst6API

This gem is dedicated for interaction with PolyAnalyst 6.x API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'polyanalyst6api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install polyanalyst6api

## Usage

All interaction with the  API is performed via an isntance of PolyAnalyst6API::Session, which maintains a particular session. The `new` method performs login using passed parameters. Example:
```ruby
session = PolyAnalyst6API::Session.new(host: 'pa_server_addr', port: 5043, v: '1.0', uname: 'user', pwd: 'password')
```
Now you can start working with a particular project if you know its UUID:
```ruby
project = session.project('7f2be16c-d7bc-4352-9151-15d765206caa')
project.nodes                    # returns information on nodes
project.execute!(<nodes list>)   # executes passed nodes
project.save!                    # saves the project
```

Full API specification is stored in the **PolyAnalyst User Manual** under the url below:
```
/polyanalyst/help/eng/26_Application_Programming_Interfaces/toc.html
```
Please, check out the page and choose the corresponding API version to explore.

Refer to [the documentation](https://www.rubydoc.info/github/Megaputer/polyanalyst6api-ruby) for more detailed information on the gem usage.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Megaputer/polyanalyst6api-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
