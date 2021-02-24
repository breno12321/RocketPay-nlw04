defmodule Rocketpay.Users.Create do
  alias Rocketpay.{Repo, User, Account}
  alias Ecto.Multi

  def call(params) do
    Multi.new()
    |> Multi.insert(:create_user, User.changeset(params))
    |> Multi.run(:create_account, fn repo, %{create_user: user} ->
      insert_account(user.id, repo)
    end)
    |> Multi.run(:preload_data, fn repo, %{create_user: user} -> preload_data(repo, user) end)
    |> run_transaction()

    # params
    # |> User.changeset()
    # |> Repo.insert()
  end

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{preload_data: user}} -> {:ok, user}
    end
  end

  defp preload_data(repo, user) do
    {:ok, repo.preload(user, :account)}
  end

  defp insert_account(user_id, repo), do: user_id |> account_changeset() |> repo.insert()
  defp account_changeset(user_id), do: Account.changeset(%{user_id: user_id, balance: 0.00})
end
