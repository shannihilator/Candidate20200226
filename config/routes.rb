Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  namespace :api, defaults: { format: "json" } do
    get :me, to: 'me#me'
    get :test, to: 'me#test'
    namespace :v1 do 
    	get :person, to: 'person#index'
    	get :people, to: 'person#getPeople'
    	get :character, to: 'person#getCharacterCount'
    	get :duplicate, to: 'person#getDuplicates'
    end
  end

  root to: "main#index"
end
