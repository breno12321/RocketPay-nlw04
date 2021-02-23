defmodule Rocketpay.Repo.Migrations.CreateUserTable do
  use Ecto.Migration

  def change do
    create table :users do
      # Define Column Name and type
      add :name, :string
      add :age, :integer
      add :email, :string
      add :password_hash, :string
      add :nickname, :string

      timestamps() #for created and updated add
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:nickname])

  end
end
