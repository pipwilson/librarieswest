require 'rubygems'
require 'test/unit'
require 'vcr'
require 'xmlsimple'
require 'uri'
require './libraries_west'

VCR.configure do |config|
  # where do we store fixtures?
  config.cassette_library_dir = 'fixtures/library_cassettes'

  # what are we using to mock our HTTP connection?
  config.hook_into :webmock # or :fakeweb

  # what should we name our cassettes in each test?
  config.around_http_request do |request|
    path = URI(request.uri).path
    cassette_name = path.slice(path.rindex('/') + 1, path.length)
    VCR.use_cassette(cassette_name, &request)
  end
end

# This class tests basic functions against the fixture data
class VCRTest < Test::Unit::TestCase
  def test_authentication
    library = LibrariesWest.new
    response = library.send_authentication
    assert_match(/Code39A/, response)
  end

  def test_fetch_loans
    library = LibrariesWest.new
    library.send_authentication
    response = library.fetch_loans
    assert_match(/<loans>/, response)
  end

  def test_renew_loan
    library = LibrariesWest.new
    library.send_authentication
    response = library.renew_loan(ENV['LOAN_ID'])
    xml = XmlSimple.xml_in(response)
    assert_match('1', xml['status'].to_s)
  end

  # def test_logout

  # end

end
