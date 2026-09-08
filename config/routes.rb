Rails.application.routes.draw do
  devise_for :users

  root "career_dashboards#show"
  resource :career_dashboard, only: :show, controller: :career_dashboards
  resource :career_profile, only: %i[show new create edit update]
  resources :user_skills, only: %i[create edit update]

  resources :job_skills
  resources :jobs
  resources :skills

  get "up" => "rails/health#show", as: :rails_health_check
end
