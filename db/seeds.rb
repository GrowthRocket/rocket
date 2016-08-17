# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


puts "创建一个 admin 账户, 3 个 user 账户，一共 5 个项目，每个项目 3 个方案，每个方案 1 笔订单"

User.create([email: 'admin@gmail.com', password: '111111', password_confirmation: '111111', is_admin: 'true'])
puts "Admin account created."

create_users = for i in 1..3 do
  User.create([email: "user#{i}@gmail.com", password: '111111', password_confirmation: '111111', is_admin: 'false', user_name: "user#{i}"])
end

puts "User account created."

create_project = for i in 1..5 do
  Project.create!([name: "Poject no.#{i}", description: "我有一个好项目 #{i} 真的很不错", user_id: 1, fund_goal: 10000 * i, is_hidden: "false", fund_progress: 3 * i * 100,
  backer_quantity: 3 ])
end

puts "10 Public Project created."

create_plan1 = for i in 1..3 do
  Plan.create!([title: "A Plan on.#{i}", description: "这是 A 的 第#{i} 个赞助方案", quantity:10, price: 100, project_id: 1, plan_goal: 100, plan_progress: 1])
end
create_plan2 = for i in 1..3 do
  Plan.create!([title: "B Plan on.#{i}", description: "这是 B 的第 #{i} 个赞助方案", quantity:10, price: 200, project_id: 2, plan_goal: 200, plan_progress: 1])
end
create_plan3 = for i in 1..3 do
  Plan.create!([title: "C Plan on.#{i}", description: "这是 C 的第 #{i} 个赞助方案", quantity:10, price: 300, project_id: 3, plan_goal: 300, plan_progress: 1])
end
create_plan4 = for i in 1..3 do
  Plan.create!([title: "D Plan on.#{i}", description: "这是 D 的第 #{i} 个赞助方案", quantity:10, price: 400, project_id: 4, plan_goal: 400, plan_progress: 1])
end
create_plan5 = for i in 1..3 do
  Plan.create!([title: "E Plan on.#{i}", description: "这是 E 的第 #{i} 个赞助方案", quantity:10, price: 500, project_id: 5, plan_goal: 500, plan_progress: 1])
end

puts "Plan auto create is done."

i = 1

create_order1 = for j in 1..3 do
    Order.create!([total_price: 100, plan_id: j, creator_name:"user#{i}", backer_name: "backer#{i}", price: 100, quantity: 1, payment_method: "Alipay", aasm_state: "paid", user_id:i+1, project_id:1])
    i = i + 1
end

i = 1
create_order2 = for j in 4..6 do
    Order.create!([total_price: 200, plan_id: j, creator_name:"user#{i}", backer_name: "backer#{i}", price: 200, quantity: 1, payment_method: "Alipay", aasm_state: "paid", user_id:i+1, project_id:2])
    i = i + 1
end
i = 1
create_order3 = for j in 7..9 do
    Order.create!([total_price: 300, plan_id: j, creator_name:"user#{i}", backer_name: "backer#{i}", price: 300, quantity: 1, payment_method: "WeChat", aasm_state: "paid", user_id:i+1, project_id:3])
    i = i + 1
end
i = 1
create_order4 = for j in 10..12 do
    Order.create!([total_price: 400, plan_id: j, creator_name:"user#{i}", backer_name: "backer#{i}", price: 400, quantity: 1, payment_method: "WeChat", aasm_state: "paid", user_id:i+1, project_id:4])
    i = i + 1
end
i = 1
create_order5 = for j in 13..15 do
    Order.create!([total_price: 500, plan_id: j, creator_name:"user#{i}", backer_name: "backer#{i}", price: 500, quantity: 1, payment_method: "WeChat", aasm_state: "paid", user_id:i+1, project_id:5])
    i = i + 1
end

puts "Order auto create is done."
