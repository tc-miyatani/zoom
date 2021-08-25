Rails.application.routes.draw do
  root to: 'rooms#index'
  resources :rooms, only: [:index, :new, :create, :show], param: :hashid do
    resources :messages, only: :create
  end
end
