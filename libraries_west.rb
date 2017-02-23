require 'uri'
require 'net/http'
require 'openssl'
require 'json'
require 'dotenv/load'

# This class handles communication with the LibrariesWest mobile app server component
class LibrariesWest

  CATALOGUE_SERVICE = 'https://m.solus.co.uk/catalogue/CatService.asmx'

  def create_http(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http
  end

  def send_authentication
    uri = URI(CATALOGUE_SERVICE + '/CatLogin?rnd=' + '234234234') #rand(2**32).to_s)
    http = create_http(uri)
    request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    request.body = { appid: ENV['APP_ID'],
                     udid: ENV['UDID'],
                     account: ENV['ACCOUNT_ID'],
                     PIN: ENV['ACCOUNT_PIN'] }.to_json
    response = http.request(request)
    response.read_body
  end

  def fetch_loans
    uri = URI(CATALOGUE_SERVICE + '/GetLoans?rnd=' + '234234234')
    http = create_http(uri)
    request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    request.body = { appid: ENV['APP_ID'],
                     udid: ENV['UDID'] }.to_json
    response = http.request(request)
    response.read_body
  end


  def renew_loan(loan_id)
    uri = URI(CATALOGUE_SERVICE + '/LoanRenew?rnd=' + '234234234')
    http = create_http(uri)
    request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    request.body = { appid: ENV['APP_ID'],
                     udid: ENV['UDID'],
                     loanID: loan_id }.to_json
    response = http.request(request)
    response.read_body
  end
end
