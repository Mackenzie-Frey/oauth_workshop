class SessionsController < ApplicationController
  def create
    client_id     = 'a310b87f10ce6f33876f'
    client_secret = '64ff40de541bf6050436e489c8387bde3e784b9b'
    code          = params[:code]
    response      = Faraday.post("https://github.com/login/oauth/access_token?client_id=#{client_id}&client_secret=#{client_secret}&code=#{code}")

    pairs = response.body.split("&")
      response_hash = {}
      pairs.each do |pair|
        key, value = pair.split("=")
        response_hash[key] = value
      end

      token = response_hash["access_token"]

      oauth_response = Faraday.get("https://api.github.com/user?access_token=#{token}")

      auth = JSON.parse(oauth_response.body)

      user          = User.find_or_create_by(uid:auth["id"])
      user.username = auth["login"]
      user.uid      = auth["id"]
      user.token    = token
      user.save

      binding.pry

    end
end
