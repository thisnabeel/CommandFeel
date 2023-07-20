Rails.application.routes.draw do
  resources :attempts
  resources :programming_language_traits

  resources :traits do 
    collection do
      post 'order', to: 'traits#order'
    end
  end

  resources :programming_languages do
    # /programming_languages/:id
    member do
      get 'traits', to: 'programming_languages#traits'
    end

    # /programming_languages/
    collection do
      post 'order', to: 'programming_languages#order'
    end
  end

  resources :algorithms do
    collection do
      post 'order', to: 'algorithms#order'
    end
  end

  resources :quiz_choices

  
  get "/users/:user_id/algorithms/:algorithm_id/attempts" => "attempts#by_user"

  
  # devise_for :users, controllers: {
  #       sessions: 'users/sessions',
  #       registrations: 'users/registrations',
  # }
  post "/users/sign_up" => "users/sessions#sign_up"
  post "/users/sign_in" => "users/sessions#create"
  get "/users/sign_out" => "users/sessions#destroy"

  get "/programming_languages/:programming_language_id/traits/:trait_id" => "programming_language_traits#find"

  post "/execute_code" => "algorithms#execute_code"
  resources :quizzes
  resources :challenges
  resources :abstractions
  resources :skills
  resources :chapters
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
