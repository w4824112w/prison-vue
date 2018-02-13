require 'sidekiq/web'

Rails.application.routes.draw do
  
  resources :users, only: :index
  resources :authentication, only: :create

  mount Sidekiq::Web => '/sidekiq'

#  root :to => 'home#index', as: 'home'

#  controller :sessions do
#    post 'login' => :create
#    delete 'logout' => :destroy
#  end

  get 'search' => 'search#search'
  #
  #修改用户密码
  #
  get 'super_user/modify_index' => 'super_user#modify_index'
  post 'super_user/modify' => 'super_user#modify'

  #
  # 审核管理员
  #

  get '/dashboard' => 'dashboard#index'

  # 用户注册审核
  patch 'registrations/:id' => 'registrations#audit'

  get '/registrations' => 'registrations#index'

  # 获取注册用户照片
  get '/registrations/:id/uuid_images' => 'registrations#images'

  # 视频会见授权
  patch 'meetings/:id' => 'meetings#audit'

  get '/meetings' => 'meetings#index'


  resources :mail_boxes do
    resources :comments
  end
  
  get '/mail_boxes/:id/check' => 'mail_boxes#check'
  
  get '/logs' => 'loggers#index'

  #
  # 狱务公开管理员
  #

  get '/news/:id/delete' => 'news#destroy'

  get 'work_news/:id/delete' => 'work_news#destroy'

  get '/laws' => 'laws#index'

  get '/laws/:id/delete' => 'laws#destroy'

  #罪犯信息导入
  get '/prisoners/import_index' => 'prisoners#import_index'
  post '/prisoners/upload' => 'prisoners#upload'
  get '/prisoners/import' => 'prisoners#import'

  post '/prisoners/upload_img' => 'prisoners#upload_img'
  post '/prisoners/del_img' => 'prisoners#del_img'

  #罪犯商品订单导入
  get '/prisoner_orders/import_index' => 'prisoner_orders#import_index'
  post '/prisoner_orders/upload' => 'prisoner_orders#upload'
  get '/prisoner_orders/import' => 'prisoner_orders#import'

  #罪犯刑期变动导入
  get '/prison_term/import_index' => 'prison_term#import_index'
  post '/prison_term/upload' => 'prison_term#upload'
  get '/prison_term/import' => 'prison_term#import'

  #罪犯奖励惩罚导入
  get '/prisoner_reward_punishment/import_index' => 'prisoner_reward_punishment#import_index'
  post '/prisoner_reward_punishment/upload' => 'prisoner_reward_punishment#upload'
  get '/prisoner_reward_punishment/import' => 'prisoner_reward_punishment#import'

  #终端设备信息
#  get '/terminals' => 'terminals#index'

  #版本信息
  get '/versions/:id/edit' => 'versions#edit'
  post '/versions/update' => 'versions#update'
  
  #附件上传
  post '/jails/update' => 'jails#update'
  post '/laws/update' => 'laws#update'
  post '/news/update' => 'news#update'


  resources :items, :news, :laws, :jails, :accounts, :prisoners, :families, :orders, :super_user, :terminals, :versions

  get '/accounts/:id' => 'accounts#show'
  #
  # 订单管理员
  #
  get '/items/:id/delete' => 'items#destroy'

  post '/items/update' => 'items#update'

  get '/sms' => 'short_messages#index'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do

      #
      # 无需用户验证api
      #

      post 'request_sms' => 'registrations#request_sms'

      post 'verify_code' => 'sessions#verify_sms_code'

      # 根据监狱名称返回 jail'id
      get 'jails/:title' => 'jails#index'

      get 'jails/:id/laws' => 'laws#index'

      get 'jails/:id/news' => 'news#index'

      post 'registrations' => 'registrations#create'

      post 'login' => 'sessions#login'

      #sessions
      # 需要用户身份验证api
      #

      post 'meetings' => 'meetings#create'

      # 发送信息到监狱长信箱
      post 'mails' => 'mail_boxes#create'

      get 'families/:id/mails' => 'mail_boxes#index'

      get 'mails/:id/comments' => 'comments#index'

      post 'feedbasessionscks' => 'feedbacks#create'

      get 'categories' => 'categories#index'

      get 'items' => 'items#index'

      get 'families/:id/balances' => 'families#balances'

      post 'news/:sessionsid/comments' => 'news#comment'

      # 获取服刑人员信息
      get 'families/:id/prisoners' => 'prisoners#index'

      # 获取服刑人员订单商品信息
      get 'families/:id/prisoner_orders' => 'prisoner_orders#index'

      # 退亲情电话款
      post 'drawbacks' => 'families#drawback'

      get 'families/:id/meetings' => 'families#meetings'

      # 获取罪犯详细信息
      get 'prisoners/:prisoner_id/detail' => 'prisoners#detail'

      # 获取罪犯刑期变动
      get 'prisoners/:prisoner_id/prisoner_terms' => 'prisoner_terms#index'

      # 获取罪犯奖励惩罚
      get 'prisoners/:prisoner_id/prisoner_reward_punishment' => 'prisoner_reward_punishment#index'


      #
      # 支付接口
      #

      # 创建订单
      post 'orders' => 'orders#create'

      # 接收支付结果
      patch 'payment_status' => 'orders#update_order_status'

      # 提交预支付（微信支付）
      post 'prepay' => 'orders#prepay'

      # 支付宝回调接口
      post 'payment' => 'payments#create'

      # 微信回调接口
      post 'weixin' => 'payments#weixin', :defaults => { :format => 'xml' }

      #
      # 监狱端api
      #

      # 获取远程视频列表
      get 'terminals/:terminal_number/meetings' => 'terminals#index'

      # 获取会议室密码
      get 'terminals/:terminal_number/detail' => 'terminals#detail'

      # 取消远程视频会见 status: cancel
      patch 'meetings/:id' => 'meetings#cancel'

      # 获取家属信息
      get 'families/:phone' => 'families#show'

      #
      # 系统api
      #

      # get version
      get 'versions/:type_id' => 'versions#show'

      # send email
      get 'send_email' => 'emailers#sendmail'

      # 上传奔溃日志
      post 'loggers' => 'loggers#create'

    end
  end

end
