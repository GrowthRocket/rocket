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

  resources :notifications do
    collection do
      post :mark_as_read
    end
  end

  root "projects#index"

  resources :projects do
    resources :plans
  end
end
