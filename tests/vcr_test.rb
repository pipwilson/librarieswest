require 'rubygems'
require 'test/unit'
require 'vcr'
require './libraries_west'

VCR.configure do |config|
  config.cassette_library_dir = 'fixtures/library_cassettes'
  config.hook_into :webmock # or :fakeweb
end

class VCRTest < Test::Unit::TestCase
  def test_example_dot_com
    VCR.use_cassette('synopsis') do
      # response = Net::HTTP.get_response(URI('http://www.iana.org/domains/reserved'))
      library = LibrariesWest.new
      response = library.send_authentication
      assert_match(/Code39A/, response)
    end
  end
end


