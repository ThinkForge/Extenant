defmodule ExtenantWeb.Router do
  use ExtenantWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ExtenantWeb do
    pipe_through :api
  end
end
