Rails.application.routes.draw do
  get 'doses/new'
  get 'doses/create'
  get 'doses/destroy'
  get 'cocktails/new'
  get 'cocktails/create'
  get 'cocktails/index'
  get 'cocktails/show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :cocktails, only: [:index, :show, :new, :create] do
    resources :doses, only: [:new, :create, :destroy]
  end

end
