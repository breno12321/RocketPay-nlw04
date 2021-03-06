defmodule Rocketpay.Accounts.Deposit do
  alias Rocketpay.{Accounts, Repo}

  def call(params) do
    params
    |> Accounts.Operation.call(:deposit)
    |> run_transaction()
  end

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{deposit: acc}} -> {:ok, acc}
    end
  end
end
