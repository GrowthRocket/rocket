Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # resources :welcome

  namespace :admin do
    resources :orders
    resources :projects do
      resources :plans
      member do
        post :publish
        post :hide
      end
    end
    resources :users do
      member do
        post :promote
        post :demote
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
    resources :users
    resources :projects do
      resources :plans
      member do
        post :publish
        post :hide
      end
    end
    resources :orders do
      member do
        post :pay_with_alipay
        post :pay_with_wechat
        post :show_orders_for_one_project
      end
    end
  end

  resources :plans do
    resources :orders
  end

  root 'projects#index'

  resources :projects do
    resources :plans
  end
end
