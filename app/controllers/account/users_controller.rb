class Account::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:send_verification_code]
  before_action :check_geetest, only: [:send_verification_code]
  before_action :phone_number_validates, only: [:verify_phone_number]
  before_action :phone_number_validates_new, only: [:verify_phone_number_new]
  layout "user"

  def index
    @user = current_user
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to account_users_path
    else
      render :edit
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def apply_for_certify
    @user = User.find(params[:id])
    @user.apply_for_certify!

    if @user.passed_verified?
      flash[:notice] = "您已通过实名认证！"
      redirect_to :back
    else
      flash[:notice] = "您已提交申请实名认证！"
      redirect_to :back
    end
  end

  # TODO: 加事务 判断接口返回的状态
  # FIXME: 你們的 service object 亂寫，寄送邏輯應該包在 service object 裡面而不是外面 by xdite
  def send_verification_code
    # if @geetest
      totp = ROTP::TOTP.new("base32secret3232")
      code = totp.now
      phone_number = params[:phone_number]
      unless VerificationCode.where(phone_number: phone_number, code_status: true).empty?
        VerificationCode.where(phone_number: phone_number, code_status: true).update_all(code_status: false)
      end
      VerificationCode.create(phone_number: phone_number, verification_code: code)
      options = { phone_number: phone_number, code: code }
      NotificationService.new(options).send_sms
      @message = { status: "y" }
      render json: @message
    # else
      # flash[:alert] = "请先滑动滑块"
      # @message = { status: "n", url: @url }
      # render json: @message
    # end
  end

  def show_verify_phone_number
    @user = current_user
  end

  def change_password
    @user = current_user
  end

  def verify_phone_number
    if @verification_code.verification_code != @user.captcha
      flash[:alert] = "验证码不正确"
      render "show_verify_phone_number"
      return
    end

    VerificationCode.where(phone_number: @user.phone_number, code_status: true).update_all(code_status: false)
    current_user.phone_number = @user.phone_number
    if current_user.save!
      current_user.approve!
      flash[:notice] = "手机验证成功"
      redirect_to account_users_path
    else
      flash[:alert] = "手机验证失败，请稍后再试。"
      render "show_verify_phone_number"
    end
  end

  def verify_phone_number_new
    if @info[:status] == "y"
      if @verification_code.verification_code != @user.captcha
        @info[:status] = "n"
        @info[:message] = "验证码不正确"
        render json: @info
        return
      end
      VerificationCode.where(phone_number: @user.phone_number, code_status: true).update_all(code_status: false)
      current_user.phone_number = @user.phone_number
      if current_user.save!
        current_user.approve!
        @info[:status] = "y"
        @info[:message] = "手机验证成功"
        render json: @info
        return
      else
        @info[:status] = "e"
        @info[:message] = "手机验证失败，请稍后再试。"
        render json: @info
        return
      end
    else
      render json: @info
      return
    end

  end

  protected

  def phone_number_validates
    @user = User.new(user_params)
    phone_number = @user.phone_number
    captcha = @user.captcha
    if phone_number.blank?
      flash[:alert] = "请输入手机号"
      render "show_verify_phone_number"
      return
    elsif captcha.blank?
      flash[:alert] = "请输入验证码"
      render "show_verify_phone_number"
      return
    end
    @verification_code = VerificationCode.select("verification_code").where(phone_number: phone_number, code_status: true).take
    if @verification_code.blank?
      flash[:alert] = "验证码错误"
      render "show_verify_phone_number"
      return
    end
  end

  def phone_number_validates_new
    @info = {}
    @info[:status] = "y"
    @info[:message] = "申请成功，请耐心等待..."
    @user = User.new(user_params)
    phone_number = @user.phone_number
    captcha = @user.captcha
    if phone_number.blank?
      @info[:status] = "n"
      @info[:message] = "请输入手机号"
      return
    elsif captcha.blank?
      @info[:status] = "n"
      @info[:message] = "请输入验证码"
      return
    end
    @verification_code = VerificationCode.select("verification_code").where(phone_number: phone_number, code_status: true).take
    binding.pry
    if @verification_code.blank?
      @info[:status] = "n"
      @info[:message] = "验证码错误"
      return
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :email, :image, :phone_number, :captcha, :weibo, :description)
  end
end
