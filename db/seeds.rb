# encoding: UTF-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#


# Jail.create(
#     {title:'测试监狱', description: '测试监狱简介', street: '通泰街街道万达广场C2栋', district: '开福区', city: '长沙市', state:'湖南省', zipcode: 'test'},
# )

Terminal.create([
    {jail_id: 2, terminal_number: '9999'},
    {jail_id: 2, terminal_number: '9998'},
    {jail_id: 2, terminal_number: '9997'}
])

Configuration.create({jail_id: 2 , settings: { cost: 50, 
  meeting_queue: [
      '9:00 - 9:30', 
      '9:30 - 10:00',
      '10:00 - 10:30',
      '10:30 - 11:00',
      '11:00 - 11:30',
      '11:30 - 12:00',
      '14:00 - 14:30',
      '14:30 - 15:00',
      '15:00 - 15:30',
      '15:30 - 16:00',
      '16:00 - 16:30',
      '16:30 - 17:00'
  ]}
})


Prisoner.create([
    # {prisoner_number: '4000001', name: '张三01', gender: 'm', crimes: '抢劫', jail_id: 1, prison_term_started_at: '2009/1/7', prison_term_ended_at: '2019/1/7'},
    # {prisoner_number: '4000002', name: '张三02', gender: 'm', crimes: '抢劫', jail_id: 1, prison_term_started_at: '2009/1/7', prison_term_ended_at: '2019/1/7'},
    # {prisoner_number: '4000003', name: '张三03', gender: 'm', crimes: '抢劫', jail_id: 1, prison_term_started_at: '2009/1/7', prison_term_ended_at: '2019/1/7'},
    # {prisoner_number: '4000004', name: '张三04', gender: 'm', crimes: '抢劫', jail_id: 1, prison_term_started_at: '2009/1/7', prison_term_ended_at: '2019/1/7'},
    # {prisoner_number: '4000005', name: '张三05', gender: 'm', crimes: '抢劫', jail_id: 1, prison_term_started_at: '2009/1/7', prison_term_ended_at: '2019/1/7'},
    # {prisoner_number: '4000006', name: '张三06', gender: 'm', crimes: '抢劫', jail_id: 1, prison_term_started_at: '2009/1/7', prison_term_ended_at: '2019/1/7'},
    # {prisoner_number: '4000007', name: '张三07', gender: 'm', crimes: '抢劫', jail_id: 1, prison_term_started_at: '2009/1/7', prison_term_ended_at: '2019/1/7'},
    # {prisoner_number: '4000008', name: '张三08', gender: 'm', crimes: '抢劫', jail_id: 1, prison_term_started_at: '2009/1/7', prison_term_ended_at: '2019/1/7'},
    # {prisoner_number: '4000009', name: '张三09', gender: 'm', crimes: '抢劫', jail_id: 1, prison_term_started_at: '2009/1/7', prison_term_ended_at: '2019/1/7'},
    # {prisoner_number: '4000010', name: '张三10', gender: 'm', crimes: '抢劫', jail_id: 1, prison_term_started_at: '2009/1/7', prison_term_ended_at: '2019/1/7'},
    # {prisoner_number: '4000011', name: '张三11', gender: 'm', crimes: '抢劫', jail_id: 1, prison_term_started_at: '2009/1/7', prison_term_ended_at: '2019/1/7'},
    # {prisoner_number: '4000012', name: '张三12', gender: 'm', crimes: '抢劫', jail_id: 1, prison_term_started_at: '2009/1/7', prison_term_ended_at: '2019/1/7'},
    # {prisoner_number: '4000016', name: '张三16', gender: 'm', crimes: '抢劫', jail_id: 1, prison_term_started_at: '2009/1/7', prison_term_ended_at: '2019/1/7'},
    # {prisoner_number: '4000014', name: '张三14', gender: 'm', crimes: '抢劫', jail_id: 1, prison_term_started_at: '2009/1/7', prison_term_ended_at: '2019/1/7'},
    # {prisoner_number: '4000015', name: '张三15', gender: 'm', crimes: '抢劫', jail_id: 1, prison_term_started_at: '2009/1/7', prison_term_ended_at: '2019/1/7'},
    # {prisoner_number: '4000016', name: '张三16', gender: 'm', crimes: '抢劫', jail_id: 1, prison_term_started_at: '2009/1/7', prison_term_ended_at: '2019/1/7'},
    # {prisoner_number: '4000017', name: '张三17', gender: 'm', crimes: '抢劫', jail_id: 1, prison_term_started_at: '2009/1/7', prison_term_ended_at: '2019/1/7'},
    # {prisoner_number: '4000018', name: '张三18', gender: 'm', crimes: '抢劫', jail_id: 1, prison_term_started_at: '2009/1/7', prison_term_ended_at: '2019/1/7'},
    # {prisoner_number: '4000019', name: '张三19', gender: 'm', crimes: '抢劫', jail_id: 1, prison_term_started_at: '2009/1/7', prison_term_ended_at: '2019/1/7'},
    {prisoner_number: '4000001', name: '张三20', gender: 'm', crimes: '抢劫', jail_id: 2, prison_term_started_at: '2009-01-07', prison_term_ended_at: '2019-01-07'},
    {prisoner_number: '4000002', name: '张三21', gender: 'm', crimes: '抢劫', jail_id: 2, prison_term_started_at: '2009-01-07', prison_term_ended_at: '2019-01-07'},
    {prisoner_number: '4000003', name: '张三22', gender: 'm', crimes: '抢劫', jail_id: 2, prison_term_started_at: '2009-01-07', prison_term_ended_at: '2019-01-07'},
    {prisoner_number: '4000004', name: '张三23', gender: 'm', crimes: '抢劫', jail_id: 2, prison_term_started_at: '2009-01-07', prison_term_ended_at: '2019-01-07'},
    {prisoner_number: '4000005', name: '张三24', gender: 'm', crimes: '抢劫', jail_id: 2, prison_term_started_at: '2009-01-07', prison_term_ended_at: '2019-01-07'}
])

# Family.create([
#     {prisoner_id: 1, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 2, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 3, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 4, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 5, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 6, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 7, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 8, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 9, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 10, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 11, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 12, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 16, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 14, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 15, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 16, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 17, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 18, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 19, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 20, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 21, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 22, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 10, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 11, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 12, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 16, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 14, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 15, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 16, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 17, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 18, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 19, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 10, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 1, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 2, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 3, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100},
#     {prisoner_id: 4, name: '张三他哥', uuid: '650104198856454', phone: '17608447120', relationship: '兄弟', balance: 100}
# ])

#Meeting.create([
    # {family_id: 1, application_date: '2017-03-16'},
    # {family_id: 2, application_date: '2017-03-16'},
    # {family_id: 3, application_date: '2017-03-16'},
    # {family_id: 4, application_date: '2017-03-16'},
    # {family_id: 5, application_date: '2017-03-16'},
    # {family_id: 6, application_date: '2017-03-16'},
    # {family_id: 7, application_date: '2017-03-16'},
    # {family_id: 8, application_date: '2017-03-16'},
    # {family_id: 9, application_date: '2017-03-16'},
    # {family_id: 10, application_date: '2017-03-16'},
    # {family_id: 11, application_date: '2017-03-16'},
    # {family_id: 12, application_date: '2017-03-16'},
    # {family_id: 16, application_date: '2017-03-16'},
    # {family_id: 14, application_date: '2017-03-16'},
    # {family_id: 15, application_date: '2017-03-16'},
    # {family_id: 16, application_date: '2017-03-16'},
    # {family_id: 17, application_date: '2017-03-16'},
    # {family_id: 18, application_date: '2017-03-16'},
    # {family_id: 19, application_date: '2017-03-16'},
    # {family_id: 20, application_date: '2017-03-16'},
    # {family_id: 21, application_date: '2017-03-16'},
    # {family_id: 22, application_date: '2017-03-16'},
    # {family_id: 23, application_date: '2017-03-16'},
    # {family_id: 24, application_date: '2017-03-16'},
    # {family_id: 25, application_date: '2017-03-16'},
    # {family_id: 26, application_date: '2017-03-16'},
    # {family_id: 27, application_date: '2017-03-16'},
    # {family_id: 28, application_date: '2017-03-16'},
    # {family_id: 29, application_date: '2017-03-16'},
    # {family_id: 30, application_date: '2017-03-16'},
    # {family_id: 31, application_date: '2017-03-16'},
    # {family_id: 32, application_date: '2017-03-16'},
    # {family_id: 33, application_date: '2017-03-16'},
    # {family_id: 34, application_date: '2017-03-16'},
    # {family_id: 3, application_date: '2017-03-16'},
#     {family_id: 16, application_date: '2017-03-16'},
#     {family_id: 31, application_date: '2017-03-16'},
#     {family_id: 35, application_date: '2017-03-16'},
#     {family_id: 36, application_date: '2017-03-16'},
#     {family_id: 4, application_date: '2017-03-16'}
# ])
#
# Item.create([
#                 {title: '8杯水男士酷爽润唇膏', description: '柔软的膏体，迅速舒缓干燥及开裂的嘴唇，有效减淡唇纹，柔嫩滋润双唇，保护双唇的健康润泽，令双唇焕发滋润光采，时刻保持健康自然唇色', price: 10, jail_id: 1, category_id: 1},
#                 {title: 'ABC8片超薄日棉卫生巾', description: ' 棉质夜用，片数8片，单片长41cm。苏菲卫生巾超熟睡410立体护围柔棉感纤巧夜用 洁翼型采用革命性超熟睡410mm巾身设计，长再加长，直达腰际，整夜安心熟睡，再也不用 担心后漏！', price: 10, jail_id: 1, category_id: 1},
#                 {title: '阿尔卑斯150g特浓牛奶糖', description: '配料： 白砂糖、葡萄糖浆、炼乳、氢化植物油、稀奶油、食品添加剂、食用盐、食用香精', price: 10, jail_id: 1, category_id: 1},
#                 {title: '阿尔卑斯31g原味糖', description: '配料： 白砂糖、葡萄糖浆、炼乳、氢化植物油、稀奶油、食品添加剂、食用盐、食用香精', price: 10, jail_id: 1, category_id: 1},
#                 {title: '爱巢248g什锦糖果', description: '香甜柔软好吃，入口及化', price: 10, jail_id: 1, category_id: 1},
#                 {title: '奥斯利600ml果粒爽', description: '满满的果粒，好喝营养又解渴', price: 10, jail_id: 1, category_id: 1},
#                 {title: '奥斯利600ml劲爆能量', description: '奥斯力功能性饮料，补充人体所需维生素，提高人体免疫力', price: 10, jail_id: 1, category_id: 1},
#                 {title: '百川全棉女袜', description: '全面吸汗，穿着舒适，耐臭，耐脏，让脚十分舒适', price: 10, jail_id: 1, category_id: 1},
#                 {title: '百事1.25L可乐', description: '碳酸饮料，百事可乐，快乐齐分享，好喝够畅快', price: 10, jail_id: 1, category_id: 1},
#                 {title: '黑人软柄牙刷', description: '柔软手柄，及软毛，能够极致清理好牙齿，让口腔十分健康', price: 10, jail_id: 1, category_id: 1}
#             ])
# Order.create([
# 	{trade_no:"111111",jail_id:1,payment_type:"kkkkkkkkkkkk",status:"ok",amount:30.00,gmt_payment:"sdasdasdas",datetime:"jaidsonasdn",family_id:1,ip:"asdasdada"},
# 	{trade_no:"111111",jail_id:1,payment_type:"kkkkkkkkkkkk",status:"ok",amount:30.00,gmt_payment:"sdasdasdas",datetime:"jaidsonasdn",family_id:1,ip:"asdasdada"},
# 	{trade_no:"111111",jail_id:1,payment_type:"kkkkkkkkkkkk",status:"ok",amount:30.00,gmt_payment:"sdasdasdas",datetime:"jaidsonasdn",family_id:1,ip:"asdasdada"},
# 	{trade_no:"111111",jail_id:1,payment_type:"kkkkkkkkkkkk",status:"ok",amount:30.00,gmt_payment:"sdasdasdas",datetime:"jaidsonasdn",family_id:1,ip:"asdasdada"},
# 	{trade_no:"111111",jail_id:1,payment_type:"kkkkkkkkkkkk",status:"ok",amount:30.00,gmt_payment:"sdasdasdas",datetime:"jaidsonasdn",family_id:1,ip:"asdasdada"},
# 	{trade_no:"111111",jail_id:1,payment_type:"kkkkkkkkkkkk",status:"ok",amount:30.00,gmt_payment:"sdasdasdas",datetime:"jaidsonasdn",family_id:1,ip:"asdasdada"},
# 	{trade_no:"111111",jail_id:1,payment_type:"kkkkkkkkkkkk",status:"ok",amount:30.00,gmt_payment:"sdasdasdas",datetime:"jaidsonasdn",family_id:1,ip:"asdasdada"},
# 	{trade_no:"111111",jail_id:1,payment_type:"kkkkkkkkkkkk",status:"ok",amount:30.00,gmt_payment:"sdasdasdas",datetime:"jaidsonasdn",family_id:1,ip:"asdasdada"},
# 	{trade_no:"111111",jail_id:1,payment_type:"kkkkkkkkkkkk",status:"ok",amount:30.00,gmt_payment:"sdasdasdas",datetime:"jaidsonasdn",family_id:1,ip:"asdasdada"},
# 	{trade_no:"111111",jail_id:1,payment_type:"kkkkkkkkkkkk",status:"ok",amount:30.00,gmt_payment:"sdasdasdas",datetime:"jaidsonasdn",family_id:1,ip:"asdasdada"},
# 	{trade_no:"111111",jail_id:1,payment_type:"kkkkkkkkkkkk",status:"ok",amount:30.00,gmt_payment:"sdasdasdas",datetime:"jaidsonasdn",family_id:1,ip:"asdasdada"},
# 	{trade_no:"111111",jail_id:1,payment_type:"kkkkkkkkkkkk",status:"ok",amount:30.00,gmt_payment:"sdasdasdas",datetime:"jaidsonasdn",family_id:1,ip:"asdasdada"},
# 	{trade_no:"111111",jail_id:1,payment_type:"kkkkkkkkkkkk",status:"ok",amount:30.00,gmt_payment:"sdasdasdas",datetime:"jaidsonasdn",family_id:1,ip:"asdasdada"},
# 	{trade_no:"111111",jail_id:1,payment_type:"kkkkkkkkkkkk",status:"ok",amount:30.00,gmt_payment:"sdasdasdas",datetime:"jaidsonasdn",family_id:1,ip:"asdasdada"},
# 	{trade_no:"111111",jail_id:1,payment_type:"kkkkkkkkkkkk",status:"ok",amount:30.00,gmt_payment:"sdasdasdas",datetime:"jaidsonasdn",family_id:1,ip:"asdasdada"},
# 	{trade_no:"111111",jail_id:1,payment_type:"kkkkkkkkkkkk",status:"ok",amount:30.00,gmt_payment:"sdasdasdas",datetime:"jaidsonasdn",family_id:1,ip:"asdasdada"},
# 	{trade_no:"111111",jail_id:1,payment_type:"kkkkkkkkkkkk",status:"ok",amount:30.00,gmt_payment:"sdasdasdas",datetime:"jaidsonasdn",family_id:1,ip:"asdasdada"}
#
#
#
#
# ])
#
#  CloudMessage.create([
#                         {jail_id: 1, accid: 'gkzxhn01'},
#                         {jail_id: 1, accid: 'gkzxhn02'},
#                         {jail_id: 1, accid: 'gkzxhn03'}
#                     ])


# Version.create({version_code:'1.0.0', version_number: 1})


User.create([
			 {username: '9999_sh', password: '123456', role: 1, jail_id: 2},
             {username: '9999_sp', password: '123456', role: 2, jail_id: 2},
             {username: '9999_xx', password: '123456', role: 3, jail_id: 2}
            ])
