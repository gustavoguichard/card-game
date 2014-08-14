DeloitteGame::Application.routes.draw do
  get '/results',   to: 'pages#results'
  get '/questions', to: 'pages#questions'
  root 'pages#game'
end
