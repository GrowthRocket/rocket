Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :welcome

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

  end

  namespace :account do
    resources :users
    resources :orders do
      member do
        post :pay_with_alipay
        post :pay_with_wechat
      end
    end
  end

  root 'projects#index'

  resources :projects do
    resources :plans
  end


end
