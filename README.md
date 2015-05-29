Sofa
==================================

```bash
# couchdb
json='
{
 "_id": "http_000000",
 "state": "healthy"
}
'

curl -H "Content-Type: application/json" -X POST -d $json http://127.0.0.1:3000/couchdb/update_state

# mongodb
json='
{
 "name": "http_000000",
 "state": "healthy"
}
'

curl -H "Content-Type: application/json" -X POST -d $json http://127.0.0.1:3000/mongodb/update_state
```
