DeloitteGame::Application.routes.draw do
  resources :evaluations

  get '/questions',     to: 'pages#questions'
  get '/new_game',      to: 'pages#new_game'
  get '/results',       to: 'evaluations#show'
  get '/registration',  to: 'evaluations#new'
  get '/admin',         to: 'evaluations#index'
  root 'pages#game'
end