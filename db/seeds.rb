# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "创建一个 admin 账户, admin创建 5 个项目，每个项目 3 个回报，每个回报 1 笔订单，每笔订单 1 条流水。
4 个 user 账户，每个user创建1个项目，每个项目3个回报，每个回报1笔订单，每笔订单1条流水。
共6 种分类。"

User.create([email: "admin@gmail.com", password: "11111111", password_confirmation: "11111111", is_admin: "true"])
puts "Admin account created."

create_users = for i in 1..3 do
                 User.create([email: "user#{i}@gmail.com", password: "11111111", password_confirmation: "11111111", is_admin: "false", user_name: "user#{i}"])
end

User.create([email: "user4@gmail.com", password: "11111111", password_confirmation: "11111111", is_admin: "false", user_name: "许昕"])

puts "4 Users' accounts created."

# 共5个用户，1个admin
Category.create!([name: "video", chs_name: "影视"])
Category.create!([name: "music", chs_name: "音乐"])
Category.create!([name: "writing", chs_name: "写作"])
Category.create!([name: "science", chs_name: "科学"])
Category.create!([name: "technology", chs_name: "技术"])
Category.create!([name: "Painting", chs_name: "绘画"])
Category.create!([name: "others", chs_name: "其他"])


Project.create!([name: "用钢笔送你一个淡彩梦！", description: "借一场旅行，放下过去，遇见自己，然后更好地行走。
这是一个90后的追梦心愿，或许你和我有着同样的梦想，却无法亲历实现。把你的故事和梦想告诉我，我将为你私人定制一副钢笔淡彩速写梦想之作。我叫文艺，一个90后的建筑专业高材生，毕业后，瞒着家人辞掉了深圳优越的设计院工作，去寻找精心绘画的“理想国”。 ",
                 user_id: 5, fund_goal: 96_000, fund_progress: 2999,
                 backer_quantity: 1, category_id: 6, aasm_state: "online", video: ""])

Plan.create!([title: "支持者", description: "赠送《一支笔的静心之旅：钢笔淡彩风景速写》图书及一套明信片。", quantity: 1, price: 199, project_id: 1, plan_goal: 100, plan_progress: 0, backer_quantity: 0, need_add: false])
Plan.create!([title: "慷慨资助者", description: "赠送《一支笔的静心之旅：钢笔淡彩风景速写》图书、一套明信片、一本速写本、1个《樱木花道的镰仓高校前站》画彩印帆布袋。", quantity: 1, price: 299, project_id: 1,
              plan_goal: 100, plan_progress: 0, backer_quantity: 0, need_add: false])
Plan.create!([title: "VIP资助者", description: "赠送限量版私人订制钢笔淡彩风景速写作品一幅。我将给支持者单独创作绘画一幅钢笔淡彩速写作品。", quantity: 1, price: 2999, project_id: 1, plan_goal: 20,
              plan_progress: 1, backer_quantity: 1, need_add: false])

Order.create!([total_price: 2999, plan_id: 27, creator_name: "许昕", backer_name: "李项", price: 2999, quantity: 1, payment_method: "Alipay", aasm_state: "paid", user_id: 5, project_id: 1, plan_description: "赠送《一支笔的静心之旅：钢笔淡彩风景速写》图书及一套明信片。", project_name: "用钢笔送你一个淡彩梦！"])
BillPayment.create(
  order_id: 16, channel_id: 0,
  amount: 2999, user_id: 5, backer_name: "李项", project_id: 1, project_name: "用钢笔送你一个淡彩梦！",
  plan_id: 34, bill_status: "success", payment_method: "Alipay", plan_description: "赠送《一支笔的静心之旅：钢笔淡彩风景速写》图书及一套明信片。"
)

Post.create!([description: "这个世界很大，只要你愿意去看。", project_id: "1"])
Post.create!([description: "很多时候我们看到的是我们想看到的，我们所见只是我们心中的真相。", project_id: "1"])
Post.create!([description: "旅行远不止走马观花，而是见天见地，见自己，走过足够远的路，才会懂自己。", project_id: "1"])
Post.create!([description: "云南大理是个神奇的地方，同样的人来到这，行为不同了，心境也不同了。希望有时间能够再来。", project_id: "1"])
Post.create!([description: "今天创作了3幅钢笔淡彩画，感谢你们的支持，我们一起完成梦想。", project_id: "1"])

puts "pen project is done."


Project.create!([name: "梵高地图 虚拟现实艺术大展", description: "科技与艺术的融合，虚拟与现实的碰撞。时间与时空的交错，苦难与人生的呈现。因为您的支持，让一切可能延续。",
                 user_id: 2, fund_goal: 200_000, fund_progress: 1000,
                 backer_quantity: 1, category_id: 6, aasm_state: "online", video: ""])

Plan.create!([title: "支持者", description: "赠送价值 125 元的《梵高地图：追寻梵高一生的轨迹》图书一本。", quantity: 1, price: 1000, project_id: 2, plan_goal: 10, plan_progress: 0, backer_quantity: 0, need_add: false])
Plan.create!([title: "慷慨资助者", description: "价值 125 元的《梵高地图：追寻梵高一生的轨迹》图书一本、价值 99 元梵高纪念版花球一盒（6个）、价值 128 元梵高纪念版糖果一盒（10支）", quantity: 1, price: 5000, project_id: 1,
              plan_goal: 20, plan_progress: 1, backer_quantity: 1, need_add: false])
Plan.create!([title: "VIP资助者", description: "价值 999 元专属定制版《梵高地图：追寻梵高一生的轨迹》图书一本（图书封面提现收藏者姓名）、价值 129 元梵高纪念版 AR （虚拟现实）眼镜一副、价值 99 元 梵高纪念版花球一盒（6个）、价值 128 元梵高纪念版糖果一盒（10支）以及价值 20000 元青年画家陆宏斌画作一副。", quantity: 1, price: 10_000, project_id: 2, plan_goal: 9,
              plan_progress: 0, backer_quantity: 0, need_add: false])

Order.create!([total_price: 5000, plan_id: 5, creator_name: "梦见斌", backer_name: "李想", price: 5000, quantity: 1, payment_method: "Alipay", aasm_state: "paid", user_id: 2, project_id: 2, plan_description: "价值 125 元的《梵高地图：追寻梵高一生的轨迹》图书一本、价值 99 元梵高纪念版花球一盒（6个）、价值 128 元梵高纪念版糖果一盒（10支）", project_name: "梵高地图 虚拟现实艺术大展"])
BillPayment.create(
  order_id: 2, channel_id: 0,
  amount: 5000, user_id: 2, backer_name: "李想", project_id: 2, project_name: "梵高地图 虚拟现实艺术大展",
  plan_id: 5, bill_status: "success", payment_method: "Alipay", plan_description: "价值 125 元的《梵高地图：追寻梵高一生的轨迹》图书一本、价值 99 元梵高纪念版花球一盒（6个）、价值 128 元梵高纪念版糖果一盒（10支）"
)

Post.create!([description: "在图书出版过程中，我萌生了一个想法——将先进科技与传统艺术相结合举办一场真真切切追寻梵高脚步的展览", project_id: "2"])
Post.create!([description: "我得到了梵高美术馆、荷兰大使馆以及荷兰旅游局的肯定与支持。", project_id: "2"])
Post.create!([description: "AR 有了新的图片，期待与你见面。", project_id: "2"])

puts "fangao project is done."


Project.create!([name: "《心灵的远方》摄影集众筹", description: "在 2006 年至 2014 年这 8 年间，我游历了内蒙、西藏、新疆、青海、四川、云南等省份，在旅程中，我收获了风光摄影的作品，同时也加深了对全国各地风土人情、地域文化的了解，定格了许多表情丰富、情感真挚、个性鲜明的民族人物摄影。因为充满未知，所以每一段旅程都让我倍感期待和兴奋；每一次历尽艰辛的到达和探访，都是一种收获和感动。我想通过这个平台将我的旅程经历分享给大家，通过台历、冰箱贴、明信片、摄影集、版画等方式，让大家感受到我在行走中捕捉到的那动人心魄的瞬间。",
                 user_id: 3, fund_goal: 4500, fund_progress: 500,
                 backer_quantity: 1, category_id: 1, aasm_state: "online", video: ""])

Plan.create!([title: "支持者", description: "您将获得《心灵的远方》电子版一套（每套 8 张）。", quantity: 1, price: 5, project_id: 3, plan_goal: 100, plan_progress: 0, backer_quantity: 0, need_add: false])
Plan.create!([title: "慷慨资助者", description: "价值 299 元精装珍藏版《心灵的远方》影集一本；《心灵的远方》摄影明信片一套（每套 8 张）。", quantity: 1, price: 500, project_id: 3,
              plan_goal: 2, plan_progress: 1, backer_quantity: 1, need_add: false])
Plan.create!([title: "VIP资助者", description: "价值 299 元精装珍藏版《心灵的远方》影集一本；《心灵的远方》摄影明信片一套（每套 8 张）。《心灵的远方》摄影台历一本；《心灵的远方》系列 32 开硬面笔记本。《心灵的远方》摄影艺术限量版原作一副；", quantity: 1, price: 1500, project_id: 3, plan_goal: 2,
              plan_progress: 0, backer_quantity: 0, need_add: false])

Order.create!([total_price: 500, plan_id: 7, creator_name: "吴涛", backer_name: "纪梵希", price: 500, quantity: 1, payment_method: "Alipay", aasm_state: "paid", user_id: 2, project_id: 2, plan_description: "价值 125 元的《梵高地图：追寻梵高一生的轨迹》图书一本、价值 99 元梵高纪念版花球一盒（6个）、价值 128 元梵高纪念版糖果一盒（10支）", project_name: "梵高地图 虚拟现实艺术大展"])
BillPayment.create(
  order_id: 3, channel_id: 0,
  amount: 5000, user_id: 3, backer_name: "纪梵希", project_id: 3, project_name: "《心灵的远方》摄影集众筹",
  plan_id: 8, bill_status: "success", payment_method: "Alipay", plan_description: "价值 299 元精装珍藏版《心灵的远方》影集一本；《心灵的远方》摄影明信片一套（每套 8 张）。"
)

Post.create!([description: "翻开本子，当年所有的事情、细节都会在脑海中再现。", project_id: "3"])
Post.create!([description: "在每次旅行途中，不管再晚再累、条件再艰苦，我每天都会坚持撰写摄影笔记。", project_id: "3"])
Post.create!([description: "不管多忙，我每年都会安排 1-2 次驾车远行，去追寻、定格那一幅幅感动自己、震撼观者的别样风景。", project_id: "2"])

puts "heart project is done."


puts "done"
