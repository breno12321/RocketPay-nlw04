defmodule Rocketpay.Accounts.Deposit do
  alias Ecto.Multi
  alias Rocketpay.{Account, Repo}

  def call(%{"id" => id, "value" => value}) do
    Multi.new()
    |> Multi.run(:account, fn repo, _ -> get_account(repo, id) end)
    |> Multi.run(:update_balance, fn repo, %{account: acc} -> update_balance(repo, acc, value) end)
    |> run_transaction()
  end

  defp get_account(repo, id) do
    case repo.get(Account, id) do
      nil -> {:error, "Account not found"}
      account -> {:ok, account}
    end
  end

  defp sum_values(%Account{balance: balance}, value) do
    value
    |> Decimal.cast()
    |> handle_cast(balance)
  end

  defp handle_cast({:ok, value}, balance), do: Decimal.add(value, balance)
  defp handle_cast(:error, _), do: {:error, "Invalid deposit value"}

  defp update_account({:error, _} = error, _repo, _acc), do: error

  defp update_account(value, repo, acc) do
    acc
    |> Account.changeset(%{balance: value})
    |> repo.update()
  end

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{update_balance: acc}} -> {:ok, acc}
    end
  end

  defp update_balance(repo, acc, v) do
    acc
    |> sum_values(v)
    |> update_account(repo, acc)
  end
end
