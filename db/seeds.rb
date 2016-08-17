# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


puts "创建一个 admin 账户 3 个 user 账户，一共 5 个项目，每个项目 3 个方案"

User.create([email: 'admin@gmail.com', password: '111111', password_confirmation: '111111', is_admin: 'true'])
puts "Admin account created."

create_users = for i in 1..3 do
  User.create([email: "user#{i}@gmail.com", password: '111111', password_confirmation: '111111', is_admin: 'false'])
end
puts "User account created."

create_project = for i in 1..5 do
  Project.create!([name: "Poject no.#{i}", description: "我有一个好项目 #{i} 真的很不错", user_id: 1, fund_goal: rand(10..49)*100, is_hidden: "false"])
end
puts "10 Public Project created."

create_plan1 = for i in 1..3 do
  Plan.create!([title: "A Plan on.#{i}", description: "这是 A 的 第#{i} 个赞助方案", quantity:10, price: 100, project_id: 1, plan_goal: 1000])
end
create_plan2 = for i in 1..3 do
  Plan.create!([title: "B Plan on.#{i}", description: "这是 B 的第 #{i} 个赞助方案", quantity:10, price: 200, project_id: 2, plan_goal: 2000])
end
create_plan3 = for i in 1..3 do
  Plan.create!([title: "C Plan on.#{i}", description: "这是 C 的第 #{i} 个赞助方案", quantity:10, price: 300, project_id: 3, plan_goal: 3000])
end
create_plan4 = for i in 1..3 do
  Plan.create!([title: "D Plan on.#{i}", description: "这是 D 的第 #{i} 个赞助方案", quantity:10, price: 400, project_id: 4, plan_goal: 4000])
end
create_plan5 = for i in 1..3 do
  Plan.create!([title: "E Plan on.#{i}", description: "这是 E 的第 #{i} 个赞助方案", quantity:10, price: 500, project_id: 5, plan_goal: 5000])
end

puts "Plan auto create is done."
