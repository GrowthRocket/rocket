Rails.application.routes.draw do
  get 'errors/not_found'

  get 'errors/internal_server_error'
  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all
  devise_for :users, controllers: { registrations: "devise/users/registrations"}

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "welcome#index"

  get "/how_it_works", to: "welcome#how_it_works"
  get "/about_us", to: "welcome#about_us"
  get "/help_term", to: "welcome#help_term"

  namespace :admin do
    resources :orders
    resources :categories
    resources :projects do
      resources :plans
      member do
        post :publish
        post :offline
      end
    end
    resources :projects_verify do
      member do
        post :pass_verify
        post :reject_verify
      end
    end
    resources :users do
      member do
        post :promote
        post :demote
      end
    end
    resources :bills do
      collection do
        get :show_bill_payments
        get :payout_index
        get :show_bill_payouts
        get :payments_index
        post :custom_fund_rate
      end
      member do
        post :show_bill_payments_by_project
        post :payout
      end
    end
    resources :users_verify do
      member do
        post :pass_verify
        post :reject_verify
      end
    end
  end

  namespace :account do
    resources :users do
      member do
        post :apply_for_certify
        post :send_verification_code
        get :show_verify_phone_number
        post :verify_phone_number
        get :change_password
        post :verify_phone_number_new
      end
    end
    resources :projects do
      collection do
        get :demo
      end
      resources :posts
      resources :plans do
        collection do
          post :create_plan
          get :get_plans
        end
      end
      member do
        post :apply_for_verification
        post :apply_for_verification_new
        post :offline
        post :reject_message
      end
    end
    resources :orders do
      member do
        post :pay_with_alipay
        post :pay_with_wechat
        post :show_orders_for_one_project
      end
    end
    resources :bills
  end

  resources :plans do
    resources :orders
  end

  resources :notifications do
    collection do
      post :mark_as_read
    end
  end

  resources :projects do
    resources :plans
    collection do
      get :search
    end
    member do
      get :preview
    end
  end

end
