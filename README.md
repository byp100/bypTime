# BYP Time
A web application to manage BYP membership and attendance

## Development
#### Requirements
- ruby
- postgres

#### Run Locally
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

## Deployment
#### Requirements
- heroku account/access
- heroku cli

#### Deploy
```
heroku git:remote -a byptime
git push heroku master
```

#### Logs | Console | Bash | Migrations
```
heroku logs --tail
heroku run rails console
heroku run bash
heroku run rake db:migrate
```
