# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "创建一个 admin 账户, admin创建 5 个项目，每个项目 3 个方案，每个方案 1 笔订单，每笔订单 1 条流水。
4 个 user 账户，每个user创建1个项目，每个项目3个方案，每个方案1笔订单，每笔订单1条流水。
共6 种分类。"


User.create([email: "admin@gmail.com", password: "111111", password_confirmation: "111111", is_admin: "true"])
puts "Admin account created."

create_users = for i in 1..3 do
                 User.create([email: "user#{i}@gmail.com", password: "111111", password_confirmation: "111111", is_admin: "false", user_name: "user#{i}"])
end

User.create([email: "user4@gmail.com", password: '111111', password_confirmation: '111111', is_admin: 'false', user_name: "许昕"])

puts "4 Users' accounts created."

#共5个用户，1个admin
Category.create!([name: "video", chs_name: "影视"])
Category.create!([name: "music", chs_name: "音乐"])
Category.create!([name: "writing", chs_name: "写作"])
Category.create!([name: "science", chs_name: "科学"])
Category.create!([name: "technology", chs_name: "技术"])
Category.create!([name: "Painting", chs_name: "绘画"])

puts "6 Categories created."

create_project = for i in 1..5 do
   Project.create!([name: "Poject no.#{i}", description: "我有一个好项目 #{i} 真的很不错", user_id: 1, fund_goal: 10_000 * i, fund_progress: 600 * i,
                    backer_quantity: 3, category_id: i, aasm_state: "project_created", video: ""])
end


puts "5 Public Project created."

create_plan1 = for i in 1..3 do
                 Plan.create!([title: "A Plan on.#{i}", description: "这是 A 的 第#{i} 个赞助方案", quantity: 1, price: 100 * i, project_id: 1, plan_goal: 100, plan_progress: 1, backer_quantity: 1])
end
create_plan2 = for i in 1..3 do
                 Plan.create!([title: "B Plan on.#{i}", description: "这是 B 的第 #{i} 个赞助方案", quantity: 1, price: 200 * i, project_id: 2, plan_goal: 200, plan_progress: 1, backer_quantity: 1])
end
create_plan3 = for i in 1..3 do
                 Plan.create!([title: "C Plan on.#{i}", description: "这是 C 的第 #{i} 个赞助方案", quantity: 1, price: 300 * i, project_id: 3, plan_goal: 300, plan_progress: 1, backer_quantity: 1])
end
create_plan4 = for i in 1..3 do
                 Plan.create!([title: "D Plan on.#{i}", description: "这是 D 的第 #{i} 个赞助方案", quantity: 1, price: 400 * i, project_id: 4, plan_goal: 400, plan_progress: 1, backer_quantity: 1])
end
create_plan5 = for i in 1..3 do
                 Plan.create!([title: "E Plan on.#{i}", description: "这是 E 的第 #{i} 个赞助方案", quantity: 1, price: 500 * i, project_id: 5, plan_goal: 500, plan_progress: 1, backer_quantity: 1])
end

puts "Plan auto create is done."

i = 1

create_order1 = for j in 1..3 do
    Order.create!([total_price: 100 * i, plan_id: j, creator_name: "user#{i}", backer_name: "backer#{i}", price: 100 * i, quantity: 1, payment_method: "Alipay", aasm_state: "paid", user_id: i + 1, project_id: 1])

    BillPayment.create(
      order_id: j, channel_id: 0,
      amount: 100 * i, user_id: i + 1, backer_name: "backer#{i}", project_id: 1, project_name: "Poject no.1",
      plan_id: j, bill_status: "success", payment_method: "Alipay"
    )
    i += 1
end

i = 1
create_order2 = for j in 4..6 do
    Order.create!([total_price: 200 * i, plan_id: j, creator_name: "user#{i}", backer_name: "backer#{i}", price: 200 * i, quantity: 1, payment_method: "Alipay", aasm_state: "paid", user_id: i + 1, project_id: 2])

    BillPayment.create(
      order_id: j, channel_id: 0,
      amount: 200 * i, user_id: i + 1, backer_name: "backer#{i}", project_id: 2, project_name: "Poject no.2",
      plan_id: j, bill_status: "success", payment_method: "Alipay"
    )

    i += 1
end
i = 1
create_order3 = for j in 7..9 do
    Order.create!([total_price: 300 * i, plan_id: j, creator_name: "user#{i}", backer_name: "backer#{i}", price: 300 * i, quantity: 1, payment_method: "WeChat", aasm_state: "paid", user_id: i + 1, project_id: 3])

    BillPayment.create(
      order_id: j, channel_id: 0,
      amount: 300 * i, user_id: i + 1, backer_name: "backer#{i}", project_id: 3, project_name: "Poject no.3",
      plan_id: j, bill_status: "success", payment_method: "Alipay"
    )
    i += 1
end
i = 1
create_order4 = for j in 10..12 do
    Order.create!([total_price: 400 * i, plan_id: j, creator_name: "user#{i}", backer_name: "backer#{i}", price: 400 * i, quantity: 1, payment_method: "WeChat", aasm_state: "paid", user_id: i + 1, project_id: 4])

    BillPayment.create(
      order_id: j, channel_id: 0,
      amount: 400 * i, user_id: i + 1, backer_name: "backer#{i}", project_id: 4, project_name: "Poject no.4",
      plan_id: j, bill_status: "success", payment_method: "Alipay"
    )
    i += 1
end
i = 1
create_order5 = for j in 13..15 do
    Order.create!([total_price: 500 * i, plan_id: j, creator_name: "user#{i}", backer_name: "backer#{i}", price: 500 * i, quantity: 1, payment_method: "WeChat", aasm_state: "paid", user_id: i + 1, project_id: 5])

    BillPayment.create(
      order_id: j, channel_id: 0,
      amount: 500 * i, user_id: i + 1, backer_name: "backer#{i}", project_id: 5, project_name: "Poject no.5",
      plan_id: j, bill_status: "success", payment_method: "Alipay"
    )
    i += 1
end

puts "Admin's Order and bill_payment auto create is done."

Project.create!([name: "User1's Poject", description: "user1 有一个好项目，真的很不错", user_id: 2, fund_goal: 1000, fund_progress: 100,
                 backer_quantity: 1, category_id: 1, aasm_state: "online", video: ""])

Project.create!([name: "User2's Poject", description: "user2 有一个好项目，真的很不错", user_id: 3, fund_goal: 2000, fund_progress: 100,
                 backer_quantity: 1, category_id: 2, aasm_state: "verifying", video: ""])

Project.create!([name: "User3's Poject", description: "user3 有一个好项目，真的很不错", user_id: 4, fund_goal: 3000, fund_progress: 100,
                 backer_quantity: 1, category_id: 3, aasm_state: "online", video: ""])


Project.create!([name: "用钢笔送你一个淡彩梦！", description: "借一场旅行，放下过去，遇见自己，然后更好地行走。
这是一个90后的追梦心愿，或许你和我有着同样的梦想，却无法亲历实现。把你的故事和梦想告诉我，我将为你私人定制一副钢笔淡彩速写梦想之作。我叫文艺，一个90后的建筑专业高材生，毕业后，瞒着家人辞掉了深圳优越的设计院工作，去寻找精心绘画的“理想国”。 ",
user_id: 5, fund_goal: 96000, fund_progress: 2999,
backer_quantity: 1, category_id: 6, aasm_state: "offline", video: "" ])


puts "4 Users' Projects created."

# user1_create_plan = for i in 1..3 do
#   Plan.create!([title: "user1 Plan on.#{i}", description: "这是 user1 的 第#{i} 个赞助方案", quantity:1, price: 100 * i, project_id: 6, plan_goal: 10, plan_progress: 1, backer_quantity: ])
# end

Plan.create!([title: "user1 Plan on.1", description: "这是 user1 的 第 1 个赞助方案", quantity:1, price: 100, project_id: 6, plan_goal: 10, plan_progress: 1, backer_quantity: 1])
Plan.create!([title: "user1 Plan on.2", description: "这是 user1 的 第 2 个赞助方案", quantity:1, price: 200, project_id: 6, plan_goal: 10, plan_progress: 0, backer_quantity: 0])
Plan.create!([title: "user1 Plan on.3", description: "这是 user1 的 第 3 个赞助方案", quantity:1, price: 300, project_id: 6, plan_goal: 10, plan_progress: 0, backer_quantity: 0])


# user2_create_plan = for i in 1..3 do
#   Plan.create!([title: "user2 Plan on.#{i}", description: "这是 user2 的 第#{i} 个赞助方案", quantity:1, price: 200 * i, project_id: 7, plan_goal: 10, plan_progress: 1, backer_quantity: 1])
# end

Plan.create!([title: "user2 Plan on.1", description: "这是 user2 的 第 1 个赞助方案", quantity:1, price: 100, project_id: 7, plan_goal: 10, plan_progress: 1, backer_quantity: 1])
Plan.create!([title: "user2 Plan on.2", description: "这是 user2 的 第 2 个赞助方案", quantity:1, price: 200, project_id: 7, plan_goal: 10, plan_progress: 0, backer_quantity: 0])
Plan.create!([title: "user2 Plan on.3", description: "这是 user2 的 第 3 个赞助方案", quantity:1, price: 300, project_id: 7, plan_goal: 10, plan_progress: 0, backer_quantity: 0])


# user3_create_plan = for i in 1..3 do
#   Plan.create!([title: "user3 Plan on.#{i}", description: "这是 user3 的 第#{i} 个赞助方案", quantity:1, price: 300 * i, project_id: 8, plan_goal: 10, plan_progress: 1, backer_quantity: 1])
# end

Plan.create!([title: "user3 Plan on.1", description: "这是 user3 的 第 1 个赞助方案", quantity:1, price: 100, project_id: 8, plan_goal: 10, plan_progress: 1, backer_quantity: 1])
Plan.create!([title: "user3 Plan on.2", description: "这是 user3 的 第 2 个赞助方案", quantity:1, price: 200, project_id: 8, plan_goal: 10, plan_progress: 0, backer_quantity: 0])
Plan.create!([title: "user3 Plan on.3", description: "这是 user3 的 第 3 个赞助方案", quantity:1, price: 300, project_id: 8, plan_goal: 10, plan_progress: 0, backer_quantity: 0])



Plan.create!([title: "支持者", description: "赠送《一支笔的静心之旅：钢笔淡彩风景速写》图书及一套明信片。", quantity:1, price:199, project_id: 9, plan_goal: 100, plan_progress: 0, backer_quantity: 0])
Plan.create!([title: "慷慨资助者", description: "赠送《一支笔的静心之旅：钢笔淡彩风景速写》图书、一套明信片、一本速写本、1个《樱木花道的镰仓高校前站》画彩印帆布袋。", quantity:1, price: 299, project_id: 9,
plan_goal: 100, plan_progress: 0, backer_quantity: 0])
Plan.create!([title: "VIP资助者", description: "赠送限量版私人订制钢笔淡彩风景速写作品一幅。我将给支持者单独创作绘画一幅钢笔淡彩速写作品。", quantity:1, price: 2999, project_id: 9, plan_goal: 20,
plan_progress: 1, backer_quantity: 1])

puts "12  Plans created."

Order.create!([total_price: 100, plan_id: 16, creator_name: "user1", backer_name: "backer3", price: 100, quantity: 1, payment_method: "Alipay", aasm_state: "paid", user_id: 3, project_id: 6])
BillPayment.create(
  order_id: 16, channel_id: 0,
  amount: 100, user_id: 3, backer_name: "backer3", project_id: 6, project_name: "User1's Poject",
  plan_id: 16, bill_status: "success", payment_method: "Alipay"
)

Order.create!([total_price: 100, plan_id: 19, creator_name: "user2", backer_name: "backer1", price: 100, quantity: 1, payment_method: "Alipay", aasm_state: "paid", user_id: 1, project_id: 7])
BillPayment.create(
  order_id: 17, channel_id: 0,
  amount: 100, user_id: 1, backer_name: "backer1", project_id: 7, project_name: "User2's Poject",
  plan_id: 19, bill_status: "success", payment_method: "Alipay"
)

Order.create!([total_price: 100, plan_id: 22, creator_name: "user3", backer_name: "backer2", price: 100, quantity: 1, payment_method: "Alipay", aasm_state: "paid", user_id: 2, project_id: 8])
BillPayment.create(
  order_id: 16, channel_id: 0,
  amount: 100, user_id: 2, backer_name: "backer2", project_id: 8, project_name: "User3's Poject",
  plan_id: 22, bill_status: "success", payment_method: "Alipay"
)

  Order.create!([total_price: 2999, plan_id: 27, creator_name:"许昕", backer_name: "李项", price: 2999 , quantity: 1, payment_method: "Alipay", aasm_state: "paid", user_id: 5, project_id:9])
  BillPayment.create(order_id: 16, channel_id: 0,
  amount: 2999, user_id: 5, backer_name: "李项", project_id: 9, project_name: "用钢笔送你一个淡彩梦！",
  plan_id: 27, bill_status: "success", payment_method: "Alipay")


  Post.create!([description:"这个世界很大，只要你愿意去看。", project_id: "9" ])
  Post.create!([description:"很多时候我们看到的是我们想看到的，我们所见只是我们心中的真相。", project_id: "9" ])
  Post.create!([description:"旅行远不止走马观花，而是见天见地，见自己，走过足够远的路，才会懂自己。", project_id: "9" ])
  Post.create!([description:"云南大理是个神奇的地方，同样的人来到这，行为不同了，心境也不同了。希望有时间能够再来。", project_id: "9" ])
  Post.create!([description:"今天创作了3幅钢笔淡彩画，感谢你们的支持，我们一起完成梦想。", project_id: "9" ])



puts "User's Order and bill_payment auto create is done."
