Rails.application.routes.draw do
  resources :comprehension_questions
  resources :leetcode_problems
  resources :code_flow_elements
  resources :trade_off_aspects
  resources :trade_off_aspect_contenders
  resources :trade_off_contenders
  resources :trade_offs
  resources :test_cases
  resources :project_skills
  resources :projects
  resources :proof_links
  resources :proofs
  resources :saved_jobs
  resources :quiz_sets
  resources :user_quiz_statuses
  resources :language_algorithm_starters
  resources :attempts
  resources :programming_language_traits

  # Direct route for quests
  resources :quests, only: [:show] do
    collection do
      get :popular
    end
    member do
      post 'quest_wizard'  # POST /quests/:id/quest_wizard
    end
    collection do
      get :by_code
    end
  end

  # Direct route for quest steps and their choices
  resources :quest_steps, only: [] do
    resources :quest_step_choices
  end

  resources :skills do
    resources :quests do
      resources :quest_steps do
        member do
          post 'upload_image'
        end
      end
    end
    resources :scripts, only: [:index, :create, :update, :destroy] do
      collection do
        post :reorder
      end
    end
    resources :phrases, only: [:index, :create, :destroy], controller: 'phrases'
    resources :tags, only: [:index, :create, :destroy], controller: 'tags'
    resources :challenges, only: [:index], controller: 'skills/challenges'
    resources :skill_histories, only: [:index, :create]
  end

  resources :quests do
    resources :quest_steps do
      member do
        post 'upload_image'
      end
    end
  end

  resources :wonders do
    collection do
      post :generate_arcade
      get :arcade
    end
    member do
      post 'generate_quiz'
      post 'generate_challenge'
      post 'generate_abstraction'
    end
    resources :quests do
      resources :quest_steps do
        member do
          post 'upload_image'
        end
      end
    end
    resources :scripts, only: [:index, :create, :update, :destroy] do
      collection do
        post :reorder
      end
    end
    resources :phrases, only: [:index, :create, :destroy], controller: 'phrases'
    resources :tags, only: [:index, :create, :destroy], controller: 'tags'
  end

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

  post "/proofs/find" => "proofs#find"

  post "/upload_avatar" => "users#upload_avatar"
  post "/users/find_by_username" => "users#find_by_username"
  patch "/users/profile" => "users#update_profile"
  put "/users/profile" => "users#update_profile"

  post "/trade_offs/make" => "trade_offs#make"

  post "/trade_offs/prompt" => "trade_offs#prompt"

  post "/resumes/prompt" => "resumes#prompt"

  get '/programming_languages/:id/challenges' => "programming_languages#challenges"

  post "/programming_languages/:id/execute" => "programming_languages#execute"

  get "/control_panel/empty_abstractions" => "control_panel#empty_abstractions"
  get "/control_panel/empty_quizzes" => "control_panel#empty_quizzes"

  get "/users/:id/user_quiz_statuses" => "user_quiz_statuses#by_user"
  get "/users/:id/jobs" => "saved_jobs#by_user"

  get "/saved_jobs/:id/find_skills" => "saved_jobs#find_skills"
  post "/quizzes/generate_choices" => "quizzes#generate_choices"
  get "/programming_languages/:id/starters" => "language_algorithm_starters#by_language"

  post "/algorithms/:id/execute" => "algorithms#execute"
  put '/algorithms/reorder' => "algorithms#reorder"

  
  resources :algorithms do
    collection do
      post 'order', to: 'algorithms#order'
    end
  end
  
  
  get "/language_algorithm_starters/finder/:language_id/:algorithm_id" => "language_algorithm_starters#finder"
  resources :quiz_choices
  resources :quizzes
  
  get "/users/:user_id/algorithms/:algorithm_id/attempts" => "attempts#by_user_algorithm"
  get "/users/:user_id/languages/:programming_language_id/attempts" => "attempts#by_user_language"

  post "/quizzes/batch_test" => "quizzes#batch_test"
  
  post "/skills/generate_quiz" => "skills#generate_quiz"
  post "/skills/generate_challenge" => "skills#generate_challenge"
  post "/skills/generate_abstraction" => "skills#generate_abstraction"
  post "/skills/generate_history" => "skills#generate_history"
  post "/infrastructure_patterns/generate" => "infrastructure_patterns#generate_patterns"

  # devise_for :users, controllers: {
  #       sessions: 'users/sessions',
  #       registrations: 'users/registrations',
  # }
  post "/users/sign_up" => "users/sessions#sign_up"
  post "/users/sign_in" => "users/sessions#create"
  get "/users/sign_out" => "users/sessions#destroy"

  get "/programming_languages/:programming_language_id/traits/:trait_id" => "programming_language_traits#find"

  post "/execute_code" => "algorithms#execute_code"
  resources :challenges do
    resources :resume_points, only: [:index, :show, :create, :update, :destroy] do
      collection do
        get :wizard
      end
    end
  end
  resources :abstractions
  resources :skill_histories, only: [:show, :update, :destroy]
  resources :skills
  resources :chapters

  resources :occupations do
    resources :occupation_skills, only: %i[index create]
    get 'my_notes', to: 'occupation_skill_user_notes#for_occupation'
    get 'my_approved_evidences', to: 'occupation_skill_evidences#approved_for_occupation'
    get 'unresolved_question_counts', to: 'questions#unresolved_counts_for_occupation'
  end
  resources :occupation_skills, only: %i[show update destroy] do
    resources :occupation_skill_user_notes, only: %i[index create]
    resources :occupation_skill_evidences, only: %i[index create]
    get 'questions', to: 'questions#for_occupation_skill'
  end
  resources :occupation_skill_user_notes, only: %i[update destroy]
  resources :occupation_skill_evidences, only: %i[update destroy] do
    collection do
      get :pending
      get :mine_approved
    end
    member do
      post :resume_bullet
    end
  end
  resources :evidence_bullets, only: %i[update destroy]
  resources :questions, only: %i[show create] do
    collection do
      get :mine
      get :cohort_unresolved
    end
    member do
      post :resolve
    end
    resources :question_comments, only: %i[create]
  end
  resources :cohorts do
    resources :cohort_sprints, only: %i[index create]
    member do
      post :enter_as_admin
    end
  end
  resources :cohort_sprints, only: %i[show update destroy] do
    member do
      post :activate
    end
  end
  resources :cohort_users do
    collection do
      get :mine
    end
    member do
      post :apply
    end
  end

  resources :feature_flags

  namespace :admin do
    resources :job_statuses, only: [:index, :show]
  end

  resources :infrastructure_patterns do
    collection do
      post :reorder
      get '/by_wonder/:wonder_id', to: 'infrastructure_patterns#by_wonder'
    end
    
    member do
      post :add_dependency
      delete '/dependencies/:dependency_id', to: 'infrastructure_patterns#remove_dependency'
    end
  end

  # Direct routes for scripts
  resources :scripts, only: [:show, :update, :destroy, :index] do
    collection do
      post :script_wizard
    end
  end

  # Direct routes for phrases
  resources :phrases do
    member do
      post :suggest_technologies
    end
    collection do
      post :generate
    end
  end

  resources :code_comparisons do
    member do
      get :answerable
      post :attach_answerable
      delete :detach_answerable
    end

    collection do
      get :arcade
      post :generate_solid_comparison
    end
    
    resources :code_blocks do
      collection do
        post :reorder
      end
    end

    resources :tags, only: [:index, :create, :destroy], controller: 'tags'
  end

  # Direct route for deleting code blocks
  delete 'code_blocks/:id', to: 'code_blocks#direct_destroy'

  # Direct tag management
  resources :tags, except: [:new, :edit] do
    collection do
      get :search
    end
    member do
      get :taggables
    end
  end

  # Direct routes for code blocks
  resources :code_blocks, only: [:update, :destroy]

  resources :quest_step_choices, only: [:show, :update, :destroy]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
