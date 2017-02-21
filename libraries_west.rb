require 'uri'
require 'net/http'
require 'openssl'
require 'json'
require 'dotenv/load'

# This class handles communication with the LibrariesWest mobile app server component
class LibrariesWest

  def initialize
    @url = URI('https://m.solus.co.uk/catalogue/CatService.asmx/CatLogin?rnd=' + '234234234') #rand(2**32).to_s)
    @http = Net::HTTP.new(@url.host, @url.port)
    @http.use_ssl = true
    @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end

  def send_authentication
    request = Net::HTTP::Post.new(@url, 'Content-Type' => 'application/json')
    request.body = { appid: ENV['APP_ID'],
                     udid: ENV['UDID'],
                     account: ENV['ACCOUNT_ID'],
                     PIN: ENV['ACCOUNT_PIN'] }.to_json
    response = @http.request(request)
    response.read_body
  end

end

library = LibrariesWest.new
puts library.send_authentication
