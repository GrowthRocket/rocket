require "digest"
require "net/http"

class GeetestSDK
  VALIDATION_URL = "http://api.geetest.com/validate.php".freeze

  def initialize
    @key = ENV["GEE_TEST_KEY"]
  end

  def validate(challenge = "", validate = "", seccode = "")
    md5 = Digest::MD5.hexdigest(@key + "geetest" + challenge)

    if validate != md5
      return false
    end

    begin
      Digest::MD5.hexdigest(seccode) == post(seccode: seccode)
    rescue
      false
    end
  end # geetest_validate

  # data.is_a?(Hash)==true
  def post(data)
    uri = URI(VALIDATION_URL)
    res = Net::HTTP.post_form(uri, data)
    res.body
  end
end
