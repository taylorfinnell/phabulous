# Phabulous

Provides access to Phabriactor

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'phabulous'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install phabulous

## Usage

Configure the gem like so

```
  Phabulous.configure do |config|
    config.host = 'your server'
    config.user = 'your user'
    config.cert = 'your user\'s arc cert'
  end
```

Get some revision info

```
  Phabulous.revisions
  Phabulous.revisions.find('D197')
  Phabulous.revisions.find(197)
```

Get some user info

```
  Phabulous.user.all
```

Do a few neat things

```
  revision = Phabulous.revisions.find('D197')
  revision.author
  revision.reviewers
  revision.title
```


## Contributing

You can run Phabricator locally on your Mac for the tests by using this local install
https://bitnami.com/download/files/stacks/phabricator/20150129-0/bitnami-phabricator-20150129-0-osx-x86_64-installer.dmg

You will need to edit the spec_helper and Rakefile

1. Fork it ( https://github.com/[my-github-username]/phabulous/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
