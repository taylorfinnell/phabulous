source 'https://rubygems.org'

group :development do
  gem 'dotenv', '~> 2.2.1'

  if RUBY_VERSION < '2.0.0'
    gem 'pry', '~> 0.10'
  else
    gem 'pry-byebug', '~> 3.4.3'
  end
end

group :test do
  gem 'webmock', '~> 3.0.1'
end

gemspec
