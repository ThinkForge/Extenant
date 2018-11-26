defmodule Extenant.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :password_hash, :string, null: false
      add :avatar, :string
      add :bio, :string
      add :title, :string
      add :firstname, :string, null: false
      add :lastname, :string, null: false

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
