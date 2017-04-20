# BYP Time
A web application to manage BYP membership and attendance

## Development
###### Requirements
- ruby
- postgres

###### Run Locally
```
bundle install
rake db:migrate
rails console
```
```ruby
Organization.new(name: "City", slug:"city").save
```
```
rails server
```
navigate to [http://city.lvh.me:3000](http://city.lvh.me:3000)