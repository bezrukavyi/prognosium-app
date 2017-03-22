Rails.application.routes.draw do
  root 'application#angular'

  namespace 'api', defaults: { format: :json } do
    mount_devise_token_auth_for 'User', at: 'auth',
      controllers: { omniauth_callbacks: 'omniauth_callbacks' }

    resources :translations, only: :show
    resources :projects, except: [:edit, :new]

    resources :tasks, only: [:create, :update, :destroy] do
      resources :comments, only: [:create, :index]
    end

    resources :comments, only: [:update, :destroy] do
      resources :attachments, only: :create
    end

    resources :attachments, only: :destroy
  end

  get '*path', to: 'application#angular'
end
