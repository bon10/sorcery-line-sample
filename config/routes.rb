Rails.application.routes.draw do
  get 'oauths/oauth'
  get 'oauths/callback'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root :to => 'login#index'

  # 各種OAuthのコールバック用
  post "oauth/callback" => "oauths#callback"
  get "oauth/callback" => "oauths#callback" # for use with Github, Facebook
  get "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider

end
