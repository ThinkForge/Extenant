defmodule Extenant.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Extenant.AuthenticationService
  alias Extenant.Accounts.User
  alias Extenant.Repo

  schema "users" do

    field(:avatar, :string)
    field(:bio, :string)
    field(:email, :string)
    field(:firstname, :string)
    field(:lastname, :string)
    field(:password_hash, :string)
    field(:password, :string, virtual: true)
    field(:title, :string)

    has_many :auth_tokens, Extenant.AuthToken

    timestamps()
  end

  def sign_in(email, password) do
    case Comeonin.Bcrypt.check_pass(Repo.get_by(User, email: email), password) do
      {:ok, user} ->
        token = AuthenticationService.generate_token(user)
        Repo.insert(Ecto.build_assoc(user, :auth_tokens, %{token: token}))
      err -> err
    end
  end

  def sign_out(conn) do
    case AuthenticationService.get_auth_token(conn) do
      {:ok, token} ->
        case Repo.get_by(Extenant.AuthToken, %{token: token}) do
          nil -> {:error, :not_found}
          auth_token -> Repo.delete(auth_token)
        end
      error -> error
    end
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :avatar, :bio, :title, :firstname, :lastname])
    |> validate_required([:email, :password, :firstname, :lastname])
    |> unique_constraint(:email, downcase: true)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))

      _ ->
        changeset
    end
  end
end
