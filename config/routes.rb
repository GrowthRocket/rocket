Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :welcome

  namespace :admin do
    resources :orders
  end
  namespace :account do
    resources :order do
      member do
        post :pay_with_alipay
        post :pay_with_wechat
      end
    end
  end

  root 'welcome#index'
end
