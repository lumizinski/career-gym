Rails.application.routes.draw do
  devise_for :users

  root "career_dashboards#show"
  get "dashboard", to: "career_dashboards#show", as: :career_dashboard
  get "focus", to: "weekly_focus#show", as: :focus
  resource :career_profile, only: %i[show new create edit update]
  resources :user_skills, only: %i[create edit update]

  resources :role_skills
  resources :roles
  resources :skills
  get "skill_gaps", to: "skill_gaps#index", as: :skill_gaps
  resources :training, only: %i[index create], controller: "training"
  resources :training_items, only: :update
  resources :labs, only: %i[index show new create edit update] do
    patch :complete, on: :member
    resources :proof_of_works, path: "proof_of_work", only: %i[new create]
  end
  resources :proof_of_works, path: "proof_of_work", only: %i[index show edit update destroy]

  get "up" => "rails/health#show", as: :rails_health_check
end
