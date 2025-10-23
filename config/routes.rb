Rails.application.routes.draw do
  # opcional: healthcheck simples
  get "/health", to: proc { [200, { "Content-Type" => "application/json" }, [{ status: "ok" }.to_json]] }

  devise_for :users,
             defaults: { format: :json },
             path: "",
             path_names: {
               sign_in: "login",
               sign_out: "logout",
               registration: "signup"
             },
             controllers: {
               sessions: "users/sessions",
               registrations: "users/registrations"
             }

  # expõe /login, /logout e /signup explicitamente
  devise_scope :user do
    post   "login",  to: "users/sessions#create"
    delete "logout", to: "users/sessions#destroy"
    post   "signup", to: "users/registrations#create"
  end

  resources :materials
end
