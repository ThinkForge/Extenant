defmodule ExtenantWeb.UserView do
  use ExtenantWeb, :view
  alias ExtenantWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    user = %{user | password_hash: nil}
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      password_hash: nil,
      avatar: user.avatar,
      bio: user.bio,
      title: user.title,
      firstname: user.firstname,
      lastname: user.lastname}
  end
end
