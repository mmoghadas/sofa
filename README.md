Sofa
==================================

```bash
# couchdb(couchrest)
json='
{
 "_id": "http_000000",
 "state": "healthy"
}
'

curl -H "Content-Type: application/json" -X POST -d $json http://127.0.0.1:3000/couchrest/update_state

# mongodb (mongo driver)
json='
{
 "name": "http_000000",
 "state": "healthy"
}
'

curl -H "Content-Type: application/json" -X POST -d $json http://127.0.0.1:3000/mongo_driver/update_state


# mongodb (mongoid)
json='
{
 "name": "http_000000",
 "state": "healthy"
}
'

curl -H "Content-Type: application/json" -X POST -d $json http://127.0.0.1:3000/mongoid/update_state
```
