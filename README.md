# Ruby Binding of CloudGarage Public API

A Ruby Binding of [CloudGarage Public API](https://api.cloudgarage.jp/doc/index.html).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cloudgarage-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cloudgarage-api

## Usage

Beginning, get your API keys ('Client ID' and 'Client Secret') from the console of CloudGarage.

### Create client instance:

```ruby
require 'cloudgarage-api'
client = CloudGarage.new(client_id, client_secret)
```

### Contract APIs

```ruby
client.contracts()
#=> list of contracts

client.contracts(contract_id)
#=> infomation of a contract
```

### Image APIs

```ruby
client.images
#=> list of all images

client.images(:os) # :os, :application or :private
#=> list of OS type images
```

### Keypair APIs

```ruby
cient.keypairs
#=> list of all key pairs

client.keypairs(keypair_id)
#=> information of the key pair
```

### Server APIs

```ruby
client.servers
#=> list of all your servers

client.server_info(server_id)
#=> information of a server instance specified by UUID

client.server_auto_backup_info(server_id)
#=> information of a server auto backup specified by UUID

client.server_security_info(server_id)
#=> information of a server security specified by UUID

# create a server
client.create_server(name, root_passwd)
#=> information of new server 
# more keyword params:
#     contract_id: String
#     spec:        Hash
#     ports:       Array
#     image_id:    String
#     keyname:     String
#     comment:     String

# start / restart / restart hard / stop servers
client.start_servers(server_ids)
client.restart_servers(server_ids)
client.restart_hard_servers(server_ids)
client.stop_servers(server_ids)

# delete a server, notifyed by e-mail
client.delete_server(server_id, notify = true) # not works well
```

### Project API

```ruby
client.version
#=> version of the API
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tdtds/cloudgarage-api.
