defmodule ExtenantWeb.Router do
  use ExtenantWeb, :router

  pipeline :authenticate do
    plug(ExtenantWeb.AuthenticatePlug)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api/v1/public", ExtenantWeb do
    pipe_through(:api)

    scope "/" do
      post("/sign_in", SessionsController, :create)
      delete("/sign_out", SessionsController, :delete)
    end

    resources("/register", UserController, only: [:create])
  end

  scope "/api/v1", ExtenantWeb do
    pipe_through(:api)
    pipe_through(:authenticate)

    resources("/users", UserController, except: [:new, :edit, :create])

    resources("/404", FallbackController)
  end
end
