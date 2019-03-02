require 'cloudgarage/api'
require 'thor'
require 'pit'

module CloudGarage
  class CLI < Thor
    class_option :json, default: false, type: :boolean # show result by json

    desc 'login <id> <secret>', 'login to CloudGarage Service and get a token'
    def login(client_id, client_secret)
      client = API.new
      token = client.login(client_id, client_secret)
      save_token(token)
    end

    desc 'contracts [contract_id]', 'get contracts information'
    def contracts(contract_id = nil)
      call_api(client) do |c|
        c.contracts(contract_id)
      end
    end

    desc 'images [os|application|private]', 'get images'
    def images(image_type = nil)
      call_api(client) do |c|
        c.images(image_type)
      end
    end

    desc 'keypairs [keypair_id]', 'get SSH Key pairs'
    def keypairs(keypair_id = nil)
      call_api(client) do |c|
        c.keypairs(keypair_id)
      end
    end

    desc 'serves [server_id]', 'get servers information'
    option :backup, default: false, type: :boolean
    option :security, default: false, type: :boolean
    def servers(server_id = nil)
      call_api(client) do |c|
        if server_id
          if options[:backup]
            c.server_auto_backup_info(server_id)
          elsif options[:security]
            c.server_security_info(server_id)
          else
            c.server_info(server_id)
          end
        else
          c.servers
        end
      end
    end

    desc 'create <name> <password> [opts...]', 'create a server'
    option :contract_id, default: nil, type: :string
    option :spec, default: '', type: :string
    option :ports, default: '', type: :string
    option :image_id, default: nil, type: :string
    option :keyname, default: nil, type: :string
    option :comment, default: nil, type: :string
    def create(name, password)
      call_api(client) do |c|
        c.create_server(name, password,
          contract_id: options[:contract_id],
          image_id: options[:image_id],
          spec: JSON.parse(options[:spec]),
          ports: JSON.parse(options[:ports]),
          keyname: options[:keyname],
          comment: options[:comment]
        )
      end
    end

    desc 'start <server_id>', 'start server'
    def start(server_id)
      call_api(client) do |c|
        c.start_servers(server_id)
      end
    end

    desc 'stop <server_id>', 'stop server'
    def stop(server_id)
      call_api(client) do |c|
        c.stop_servers(server_id)
      end
    end

    desc 'restart [--hard] <server_id>', 'restart server'
    option :hard, default: false, type: :boolean
    def restart(server_id)
      call_api(client) do |c|
        if options[:hard]
          c.restart_hard_servers(server_id)
        else
          c.restart_servers(server_id)
        end
      end
    end

    desc 'delete [--notify] <server_id>', 'delete server'
    option :notify, default: true, type: :boolean
    def delete(server_id)
      call_api(client) do |c|
        c.delete_server(server_id, options[:notify])
      end
    end

  private
    CREDENTIAL_KEY = 'api.cloudgarage.jp'
    def load_token
      Pit::get(CREDENTIAL_KEY)[:token]
    end

    def save_token(token)
      Pit::set(CREDENTIAL_KEY, data: {token: token})
    end

    def client
      token = load_token
      unless token
        puts 'please login to CloudGarage API'
        print 'client id: '
        client_id = gets.chomp
        print 'client secret: '
        client_secret = gets.chomp
        token = login(client_id, client_secret)
      end
      API.new(token)
    end

    def call_api(client)
      begin
        result = yield(client)
        if options[:json]
          puts result.to_json
        else
          pp result
        end
      rescue => e
        $stderr.puts e.message
        exit 255
      end
    end
  end
end
