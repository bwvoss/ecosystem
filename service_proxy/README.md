To start it, run: rackup config.ru

- cross platform
- actually makes http requests
- lets you choose the datastore
- rake route to print out all the urls available

ServiceProxy.set_repository(repository)
fingerprint = {
  querystring: '',
  method: :get,
  response_type: :json
}

Should add assertion_data key? with data like count -- some dsl for easy assertions?

eg: ServiceProxy::Helpers.equivelent_payload?(expected_payload)
write some and see if abstractions make sense

ServiceProxy.record(fingerprint, payload)

#other fingerprint data can be used for advanced queries
#or documentation/communication with other developers

RedisRepository.put(querystring, payload, other_fingerprint_data)

#how to retrieve fingerprint data
ServiceProxy::DataAccess.get(fingerprint)
