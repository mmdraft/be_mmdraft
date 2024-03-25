Rails.application.routes.draw do
  namespace :admin do
    resources :dashboard, only: %i[index]
    resources :teams, only: %i[index show new create edit update destroy] do
      collection do
        post :destroy_all
      end
    end
    resources :leagues, only: %i[index destroy]
  end
  namespace :api do
    namespace :v0 do
      resources :users, only: %i[index show create] do
        resources :leagues, only: %i[index], controller: 'users/leagues'
      end
      resources :leagues, only: %i[create show update destroy] do
        resources :user_leagues, only: %i[index], controller: 'leagues/user_leagues'
        resources :draft_picks, only: %i[index], controller: 'leagues/draft_picks'
      end
      resources :user_leagues, only: %i[show create destroy] do
        resources :draft_picks, only: %i[index create], controller: 'user_leagues/draft_picks'
      end
      resources :teams, only: %i[index show]
    end
  end
end
