Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :welcome

  resources :projects
  namespace :admin do
    resources :projects
  end

  root 'projects#index'
end
