## Fork Notes
This is a modified fork of Datascope. This fork can be used as a rack app mounted inside another app, such as a Rails app. If you've got a devops app that you want to include Datascope in, this is your best bet.

### Install

Add `gem 'datascope'` to your app's `Gemfile`. That points to this fork.

Mount `Datascope` like you would any rack app. Here's a rails example


```ruby
#routes.rb
require 'datascope'
mount Datascope => '/db'
```

### Worker

You can run the required worker via `bundle exec datascope_worker`. This will loop forever.

### Heroku Free Setup

If you want to run this on Heroku, including worker, for free, do this.

* Install unicorn (`gem 'unicorn'`)
* Tell heroku to use unicorn (`web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb` in your `Procfile`)
* In the `before_fork` for unicorn, create a thread running the worker


```ruby
#config/unicorn.rb
…
before_fork do |server, worker|
  @worker_pid ||= spawn("bundle exec datascope_worker")
  t = Thread.new {
    Process.wait(@worker_pid)
    puts "Worker died. Killing a unicorn."
    Process.kill 'QUIT', Process.pid
  }
end
…
```

Boom. You're set up.

For more information on unicorn & heroku, see [https://devcenter.heroku.com/articles/rails-unicorn](https://devcenter.heroku.com/articles/rails-unicorn)


# Datascope
Visability into your Postgres 9.2 database via [pg_stat_statements](http://www.postgresql.org/docs/9.2/static/pgstatstatements.html) and [cubism](http://square.github.com/cubism/) and using the [json datatype](http://wiki.postgresql.org/wiki/What's_new_in_PostgreSQL_9.2#JSON_datatype).

![http://f.cl.ly/items/440Z1L1n2v3q3c1Q3J0s/datascope.png](http://f.cl.ly/items/440Z1L1n2v3q3c1Q3J0s/datascope.png)

Check out a [live example](https://datascope.herokuapp.com)

# Heroku Deploy

Datascope needs two Postgres 9.2 databases. The first is a DATABASE_URL with the datascope schema, the second is a TARGET_DB with the pg_stat_statements extension.

```bash
$ heroku create

$ heroku addons:add heroku-postgresql:dev --version=9.2
Attached as HEROKU_POSTGRESQL_COPPER_URL
$ heroku config:add DATABASE_URL=$(heroku config:get HEROKU_POSTGRESQL_COPPER_URL)
$ heroku pg:psql COPPER
=> \i schema.sql
CREATE TABLE

$ heroku addons:add heroku-postgresql:dev --version=9.2
Attached as HEROKU_POSTGRESQL_GREEN_URL

$ heroku config:add TARGET_DB=$(heroku config:get HEROKU_POSTGRESQL_GREEN_URL)
$ heroku pg:psql GREEN
=> create extension pg_stat_statements;
CREATE EXTENSION

$ git push heroku master
$ heroku scale worker=1
```

# Basic Auth

If you don't want your deployment of datascope to be publicly visible, simply add environment variables for `BASIC_AUTH_USER` and `BASIC_AUTH_PASSWORD`.

```
heroku config:add BASIC_AUTH_USER=admin BASIC_AUTH_PASSWORD=password
```
