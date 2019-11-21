# Rbvore

A Ruby gem which helps you "consume" the Omnivore.io API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rbvore'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rbvore

## Usage

### Get list of tables for a location

```rb
location_id = "xxxxx"
location = Rbvore::Location.fetch_one(id: location_id)
tables = location.tables

# or

tables = Rbvore::Table.fetch_all(location_id: location_id)
```

### Get open tickets for a given location and table
```rb
location_id = "xxxxxx"
table_id = 2
tickets = Rbvore::Ticket.fetch_all(location_id: location_id, table_id: 2, open: true)
```

### Create 3rd-party payment for ticket
```rb
payment = Rbvore::Payment.new(
  amount: 6578,
  tip: 1400,
  tender_type: "100",
).create_3rd_party(
  location_id: "xxxxx",
  ticket_id: "1",
  auto_close: true,
)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/syoder/rbvore. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rbvore project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/syoder/rbvore/blob/master/CODE_OF_CONDUCT.md).
