Rails.application.routes.draw do
  root to: 'cocktails#index'
  get '/cocktails/:id/set_picture' => 'cocktails#set_picture', as: :set_pic
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :cocktails, only: [:index, :show, :new, :create] do
    resources :doses, only: [:new, :create, :destroy]
  end

end
