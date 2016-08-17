class OrderMailer < ApplicationMailer
  def notify_order_placed(order)
    @order = order
    @user = order.user
    @project = @order.project
    @title = @project.name
    mail(to: @user.email, subject: "[Rocket] 感谢你支持 #{@title}项目")
  end
end
