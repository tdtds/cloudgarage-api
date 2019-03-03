# Ruby Binding and CLI of CloudGarage Public API

A Ruby Binding Library and CLI of [CloudGarage Public API](https://api.cloudgarage.jp/doc/index.html).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cloudgarage-api'
```

And then execute:

    $ bundle

Or install it yourself to use CLI as:

    $ gem install cloudgarage-api

## Usage of CLI (cloudgarage command)

Beginning, get your API keys ('Client ID' and 'Client Secret') from the console of CloudGarage.

```sh
$ cloudgarage help
Commands:
  cloudgarage contracts [contract_id]             # get contracts information
  cloudgarage create <name> <password> [opts...]  # create a server
  cloudgarage delete [--notify] <server_id>       # delete server
  cloudgarage help [COMMAND]                      # Describe available commands or one specific command
  cloudgarage images [os|application|private]     # get images
  cloudgarage keypairs [keypair_id]               # get SSH Key pairs
  cloudgarage login <id> <secret>                 # login to CloudGarage Service and get a token
  cloudgarage restart [--hard] <server_id>        # restart server
  cloudgarage serves [server_id]                  # get servers information
  cloudgarage start <server_id>                   # start server
  cloudgarage stop <server_id>                    # stop server

Options:
  [--json], [--no-json]
```

You can get result by JSON using `--json` option for searching or querying (ex. `jq`)

## Usage of API from ruby language

Beginning, get your API keys ('Client ID' and 'Client Secret') from the console of CloudGarage.

### Create client instance and login:

```ruby
require 'cloudgarage/api'
client = CloudGarage::API.new
token = client.login(client_id, client_secret)
```

You can use the `token` while 24H. If the token expired, try to login again.

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
client.delete_server(server_id, notify = true)
```

### Project API

```ruby
client.version
#=> version of the API
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tdtds/cloudgarage-api.
