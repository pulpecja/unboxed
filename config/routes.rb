Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'github_queries#new'
  resources :github_queries, only: %w(new create show)
end
