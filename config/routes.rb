Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html  
  get '/faces', to: 'faces#index'
  post '/faces', to: 'faces#index'
end
