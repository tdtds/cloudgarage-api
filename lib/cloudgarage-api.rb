#
# A ruby wrapper of CloudGarage public API
#
# Copyright (C) 2019 by Tada, Tadashi <t@tdtds.jp>
# You can distribute under GPL 3.0
#
require 'rest-client'

class CloudGarage
  VERSION = "0.1.0".freeze
  BASE_URI = 'https://api.cloudgarage.jp'.freeze

  def initialize(client_id, client_secret)
    @client_id, @client_secret = client_id, client_secret
    token
  end

  def token
    payload = {'client_id' => @client_id, 'client_secret' => @client_secret}
    @token = post('tokens', payload)['token']['id']
  end

  def contracts(contract_id = nil)
    if contract_id 
      get("contracts/#{contract_id}")['contract']
    else
      get('contracts')['contracts']
    end
  end

  # image_type: :os, :application, :private
  def images(image_type = nil)
    images = get("images")['images']
    if image_type
      image_type = image_type.to_s.upcase
      images.select!{|i| i['image_type'] == image_type}
    end
    return images
  end

  def keypairs(keypair_id = nil)
    if keypair_id
      get("keypairs/#{keypair_id}")['keypair']
    else
      get('keypairs')['keypairs']
    end
  end

  def servers()
    get('servers')['servers']
  end

  def server_info(server_id)
    get("servers/#{server_id}")['server_detail']
  end

  def server_auto_backup_info(server_id)
    get("servers/#{server_id}/autoBackup")['autoBackup']
  end

  def server_security_info(server_id)
    get("servers/#{server_id}/security")['securityRules']
  end

  def create_server(name, password, contract_id: nil, spec: {}, ports: [], image_id: nil, keyname: nil, comment: nil)
    payload = {'name' => name, 'password' => password}
    payload['contract_id'] = contract_id if contract_id
    payload['spec'] = spec unless spec.empty?
    payload['ports'] = ports unless ports.empty?
    payload['image_id'] = image_id if image_id
    payload['keyname'] = keyname if keyname
    payload['comment'] = comment if comment
    post('servers', payload)['resource_id']
  end

  # operation: :start, :restart, :restart_hard, :stop
  # servers: array of server UUIDs
  def operate_servers(operation, servers)
    payload = {'operate' => operation.to_s.upcase, 'servers' => [servers].flatten}
    post('servers/operate', payload)
  end
  def start_servers(servers); operate_servers(:start, servers); end
  def restart_servers(servers); operate_servers(:restart, servers); end
  def restart_hard_servers(servers); operate_servers(:restart_hard, servers); end
  def stop_servers(servers); operate_servers(:stop, servers); end

  def delete_server(resource_id, notify = true)
    delete("servers/#{resource_id}?sendMail=#{notify ? 'true': 'false'}")
  end

  def version
    get("version")['version']
  end

private
  def header
    h = {'Content-Type' => 'application/json'}
    h['X-Auth-Token'] = @token if @token
    return h
  end

  def get(api)
    parse_body(RestClient.get("#{BASE_URI}/#{api}", header))
  end

  def post(api, payload)
    parse_body(RestClient.post("#{BASE_URI}/#{api}", payload.to_json, header))
  end

  def delete(api)
    RestClient.delete("#{BASE_URI}/#{api}", header)
  end

  def parse_body(res)
    JSON.parse(res.body)
  end
end
