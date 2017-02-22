require 'rubygems'
require 'test/unit'
require 'vcr'
require './libraries_west'

VCR.configure do |config|
  config.cassette_library_dir = 'fixtures/library_cassettes'
  config.hook_into :webmock # or :fakeweb
end

class VCRTest < Test::Unit::TestCase
  def test_authentication
    VCR.use_cassette('authentication') do
      library = LibrariesWest.new
      response = library.send_authentication
      assert_match(/Code39A/, response)
    end
  end

    def test_fetch_loans
    VCR.use_cassette('loans') do
      library = LibrariesWest.new
      library.send_authentication
      response = library.fetch_loans
      assert_match(/<loans>/, response)
    end
  end

end


