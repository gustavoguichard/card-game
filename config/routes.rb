DeloitteGame::Application.routes.draw do
  get '/results', to: 'pages#results'
  root 'pages#game'
end
