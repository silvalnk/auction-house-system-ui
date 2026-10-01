source "https://rubygems.org"

gem "rails", "~> 8.1.4"
gem "propshaft"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "inertia_rails"
gem "vite_rails"

gem "packs"
gem "packs-rails"
gem "packwerk"

gem "dry-system"
gem "dry-auto_inject"
gem "dry-monads"
gem "dry-validation"

gem "rails_event_store"

gem "tzinfo-data", platforms: %i[windows jruby]
gem "bootsnap", require: false
gem "thruster", require: false

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "bundler-audit", require: false
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
end
