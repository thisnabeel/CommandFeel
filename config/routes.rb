Rails.application.routes.draw do
  resources :quizzes
  resources :challenges
  resources :abstractions
  resources :skills
  resources :chapters
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
