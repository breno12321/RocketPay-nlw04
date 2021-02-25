defmodule Rocketpay.Accounts.Operation do
  alias Rocketpay.{Account, Repo}
  alias Ecto.Multi

  def call(%{"id" => id, "value" => value}, operation) do
    operation_name = account_operation_name(operation)

    Multi.new()
    |> Multi.run(operation_name, fn repo, _ -> get_account(repo, id) end)
    |> Multi.run(operation, fn repo, changes ->
      account = Map.get(changes, operation_name)
      update_balance(repo, account, value, operation)
    end)
  end

  defp account_operation_name(operation),
    do: "account_#{Atom.to_string(operation)}" |> String.to_atom()

  defp get_account(repo, id) do
    case repo.get(Account, id) do
      nil -> {:error, "Account not found"}
      account -> {:ok, account}
    end
  end

  defp operate_balance(%Account{balance: balance}, value, operation) do
    value
    |> Decimal.cast()
    |> handle_cast(balance, operation)
  end

  defp handle_cast({:ok, value}, balance, :deposit), do: Decimal.add(balance, value)
  defp handle_cast({:ok, value}, balance, :withdraw), do: Decimal.sub(balance, value)
  defp handle_cast(:error, _, _), do: {:error, "Invalid deposit value"}

  defp update_account({:error, _} = error, _repo, _acc), do: error

  defp update_account(value, repo, acc) do
    acc
    |> Account.changeset(%{balance: value})
    |> repo.update()
  end

  defp update_balance(repo, acc, v, operation) do
    acc
    |> operate_balance(v, operation)
    |> update_account(repo, acc)
  end
end
