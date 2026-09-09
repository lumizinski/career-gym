Rails.application.routes.draw do
  devise_for :users

  root "career_dashboards#show"
  get "dashboard", to: "career_dashboards#show", as: :career_dashboard
  resource :career_profile, only: %i[show new create edit update]
  resources :user_skills, only: %i[create edit update]

  resources :role_skills
  resources :roles
  resources :skills
  get "skill_gaps", to: "skill_gaps#index", as: :skill_gaps

  get "up" => "rails/health#show", as: :rails_health_check
end
