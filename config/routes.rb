DeloitteGame::Application.routes.draw do
  resources :evaluations

  get '/results',       to: 'pages#results'
  get '/questions',     to: 'pages#questions'
  get '/registration',  to: 'evaluations#new'
  root 'pages#game'
end
