Rails.application.routes.draw do
  root to: 'rooms#index'
  resources :rooms, only: [:index, :new, :create, :show, :edit, :update, :destroy]
end
