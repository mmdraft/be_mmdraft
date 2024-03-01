Rails.application.routes.draw do
  namespace :api do
    namespace :v0 do
      resources :users, only: %i[index show create] do
        resources :leagues, only: %i[index], controller: 'users/leagues'
      end
      resources :leagues, only: %i[create show update destroy] do
        resources :user_leagues, only: %i[index], controller: 'leagues/user_leagues'
      end
      resources :user_leagues, only: %i[show create destroy] do
        resources :draft_picks, only: %i[index], controller: 'user_leagues/roster_teams'
      end
      resources :teams, only: %i[index show]
      resources :draft_picks, only: %i[create]
      resources :articles, only: %i[index]
    end
  end
end
