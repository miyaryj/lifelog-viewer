Rails.application.routes.draw do

  root 'static#top'

  resources :sessions, only: [:new, :destroy]

  get 'sessions/callback' => 'sessions#callback'

end
