Sofa
==================================
# Requires: JRuby

```bash

# you may use the client or curl:

# Client
git clone git@github.com:mmoghadas/sofa-client.git
cd sofa-client
bundle (if need to)
ruby lib/client.rb --driver couchrest --name http_0 --state unhealthy


- OR -
# With Curl:

# couchdb(couchrest)
json='
{
 "name": "http_000000",
 "state": "healthy"
}
'

curl -H "Content-Type: application/json" -X POST -d $json http://127.0.0.1:3000/couchrest/update_state "Authorization: Token token=eb025421974c0d1ad9b24a95f1ea97f5"

# mongodb (mongo driver)
json='
{
 "name": "http_000000",
 "state": "healthy"
}
'

curl -H "Content-Type: application/json" -X POST -d $json http://127.0.0.1:3000/mongo_driver/update_state "Authorization: Token token=eb025421974c0d1ad9b24a95f1ea97f5"


# mongodb (mongoid)
json='
{
 "name": "http_000000",
 "state": "healthy"
}
'

curl -H "Content-Type: application/json" -X POST -d $json http://127.0.0.1:3000/mongoid/update_state -H "Authorization: Token token=eb025421974c0d1ad9b24a95f1ea97f5"
```
