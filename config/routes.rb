Rails.application.routes.draw do
  resources :users do
    resources :tasks
  end
  post '/auth/login', to: 'authentication#login'
end
