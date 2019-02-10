require 'rest-client'

class CloudGarage
  VERSION = "0.1.0"

  class Unauthorized < ArgumentError; end
  class NotFound < ArgumentError; end
  class Failed < ArgumentError; end

  BASE_URI = 'https://api.cloudgarage.jp'
  CONTENT_TYPE = 'application/json'

  def initialize(client_id, client_secret)
    @client_id, @client_secret = client_id, client_secret
    token
  end

  def token
    payload = {'client_id' => @client_id, 'client_secret' => @client_secret}
    res = RestClient.post("#{BASE_URI}/tokens", payload.to_json, {'Content-Type' => CONTENT_TYPE})
    case res.code
    when 200
      @token = parse_body(res)['token']['id']
      return @token
    when 401
      raise Unauthorized.new
    when 404
      raise NotFound.new
    when 400
      raise Failed.new
    end
  end

  def contracts(contract_id = nil)
    if contract_id 
      get("contracts/#{contract_id}")['contract']
    else
      get('contracts')['contracts']
    end
  end

  def images(image_type = nil)
    if image_type
      get("images?imageType=#{image_type}")['images']
    else
      get("images")['images']
    end
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

  def version
    get("version")['version']
  end

private
  def get(api)
    res = RestClient.get("#{BASE_URI}/#{api}", {'Content-Type' => CONTENT_TYPE, 'X-Auth-Token' => @token})
    case res.code
    when 200
      return parse_body(res)
    when 401
      raise Unauthorized.new
    when 404
      raise NotFound.new
    when 400
      raise Failed.new
    end
  end

  def post(api, payload)
    res = RestClient.post("#{BASE_URI}/#{api}", payload.to_json, {'Content-Type' => CONTENT_TYPE, 'X-Auth-Token' => @token})
    case res.code
    when 200
      @token = parse_body(res).token
      return @token
    when 401
      raise Unauthorized.new
    when 404
      raise NotFound.new
    when 400
      raise Failed.new
    end
  end

  def parse_body(res)
    JSON.parse(res.body)
  end
end
