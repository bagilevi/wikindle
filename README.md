# Wikindle

Wikindle is a quick hack to make reading and navigating
[Wikipedia](http://wikipedia.org)
on a [Kindle](http://en.wikipedia.org/wiki/Amazon_Kindle)
more comfortable.

It is hosted at [wikindle.org](http://wikindle.org) via
[Heroku](http://heroku.com).

It is written in [Ruby](http://ruby-lang.org)
using the [Sinatra](http://sinatrarb.com) framework.

## Installation

To make the feedback form work:

Create a Heroku app.

Install the *Sendgrid* add-on.

Set your email:

    heroku config:add ADMIN_EMAIL=me@example.org

## Running locally

This is how I install it:

    rvm install 1.9.2
    rvm use 1.9.2
    rvm gemset create wikindle
    rvm use 1.9.2@wikindle
    gem install bundler --no-ri --no-rdoc
    bundle install

To be able to run it locally get your Sendgrid configuration:

    heroku config

and create a `run` script (which is .gitignore'd), like this:

    ADMIN_EMAIL=me@example.org \
    SENDGRID_DOMAIN="wikindle.org" \
    SENDGRID_PASSWORD="4fa6418571" \
    SENDGRID_USERNAME="app123456@heroku.com" \
    bundle exec rackup config.ru

