# DatabaseBackup

Welcome to database backup! formerly dropbox-database-backup (stanadole banch).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'database-backup'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install database-backup

## Usage

It is recommended, when running with rails, to execute task with whenever.

```
$ wheneverize .
```

## Example config/schedule.rb

```
  set :output, 'log/database-backup.log'
  set :environment, Rails.env

  every 1.day do # 1.minute 1.day 1.week 1.month 1.year is also supported
    rake "database_backup:backup"
  end
```

### Secrets configuration

```
development:
  # other configs
  database_backup:
    time_format: "%Y-%m-%d %H-%M-%S"
    dropbox_key: "my-dropbox-key"
```

```
$ whenever --update-crontab
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/codn/database-backup. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://github.com/codn/database-backup/blob/master/LICENSE.txt).

## Code of Conduct

Everyone interacting in the DatabaseBackup project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/codn/database-backup/blob/master/CODE_OF_CONDUCT.md).
