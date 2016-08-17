class OrderMailer < ApplicationMailer
  def notify_order_placed(order)
    @order = order
    @user = order.user

    mail(to: @user.email, subject: "[Rocket] 感谢你支持@project.name"
  end
end
