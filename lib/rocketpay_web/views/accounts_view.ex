defmodule RocketpayWeb.AccountsView do
  use RocketpayWeb, :view
  alias Rocketpay.{Account}
  alias Rocketpay.Accounts.Transactions.Response, as: TransactionResponse

  def render("update.json", %{
        account: %Account{id: account_id, balance: balance}
      }) do
    %{
      message: "Balance updated",
      account: %{
        id: account_id,
        balance: balance
      }
    }
  end

  def render("transaction.json", %{
        transaction: %TransactionResponse{
          to_acc: to_account,
          from_acc: from_account
        }
      }) do
    %{
      message: "Transaction done",
      transaction: %{
        from_account: %{
          id: from_account.id,
          balance: from_account.balance
        },
        to_account: %{
          id: to_account.id,
          balance: to_account.balance
        }
      }
    }
  end
end
