DeloitteGame::Application.routes.draw do
  get '/results',   to: 'pages#results'
  get '/questions', to: 'pages#questions'
  get '/registration', to: 'pages#registration'
  root 'pages#game'
end
