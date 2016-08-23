class NotificationService
  # def initialize(order, user, project)
  def initialize(options)
    @to_phone_number = options[:phone_number] unless options[:phone_number].nil?
    @code = options[:code] unless options[:code].nil?
  end

  def send_sms
    @client = Twilio::REST::Client.new
    @client.messages.create(
      from: ENV["TWILIO_PHONE_NUMBER"],
      to: "+86" + @to_phone_number.to_s,
      body: "你的验证码是 #{@code}"
    )
  end

end
