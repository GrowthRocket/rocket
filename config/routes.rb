Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :welcome

  root 'admin/plans#index'

  namespace :admin do
    resources :plans
  end

 resources :plans 
end
