source 'https://rubygems.org'

gem 'activesupport',          '~> 4.2.4'
gem 'httparty',               '~> 0.10.0'
gem 'rake',                   '~> 10.4.2'
gem 'light-service', git: 'https://github.com/adomokos/light-service', branch: 'master'

group :datastore do
  gem 'pg',     '~> 0.18.2'
  gem 'sequel', '~> 4.25.0'
end

group :development do
  gem 'pry', '~> 0.10.0'
  gem 'bundler-audit', '~> 0.4.0'
  gem 'flog', '~> 4.3.2', require: false
  gem 'rubocop', '~> 0.33.0', require: false
end

group :test do
  gem 'database_cleaner', '~> 1.5.0'
  gem 'rspec',            '~> 3.3.0'
end

