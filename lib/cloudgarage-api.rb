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

  def servers(server_id = nil)
    if server_id
      get("servers/#{server_id}")['server_detail']
    else
      get('servers')['servers']
    end
  end

  def create_server(name, password, contract_id: nil, spec: {}, ports: [], image_id: nil, keyname: nil, comment: nil)
    payload = {'name' => name, 'password' => password}
    payload['contract_id'] = contract_id if contract_id
    payload['spec'] = spec unless spec.empty?
    payload['ports'] = ports unless ports.empty?
    payload['image_id'] = image_id if image_id
    payload['keyname'] = keyname if keyname
    payload['comment'] = comment if comment
    pp payload
    post('servers', payload)['resource_id']
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

  def parse_body(res)
    JSON.parse(res.body)
  end
end
