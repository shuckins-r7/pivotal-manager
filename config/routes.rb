PivotalManager::Application.routes.draw do
  
  # We're a read-only app here...
  resources :members, :only => [:show, :index]

  # Give the people what they want
  root :to => 'dashboard#index'
end
