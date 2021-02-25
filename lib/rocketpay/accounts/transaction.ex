defmodule Rocketpay.Accounts.Transaction do
  alias Ecto.Multi

  alias Rocketpay.Repo
  alias Rocketpay.Accounts.Operation
  alias Rocketpay.Accounts.Transactions.Response, as: TransactionResponse

  def call(%{"from" => from_id, "to" => to_id, "value" => value}) do
    Multi.new()
    |> Multi.merge(fn _ -> Operation.call(build_params(from_id, value), :withdraw) end)
    |> Multi.merge(fn _ -> Operation.call(build_params(to_id, value), :deposit) end)
    |> run_transaction()
  end

  defp build_params(id, value), do: %{"id" => id, "value" => value}

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} ->
        {:error, reason}

      {:ok, %{deposit: to_acc, withdraw: from_acc}} ->
        {:ok, TransactionResponse.build(from_acc, to_acc)}
    end
  end
end
