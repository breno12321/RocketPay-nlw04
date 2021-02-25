defmodule Rocketpay.Accounts.Transactions.Response do
  alias Rocketpay.Account

  defstruct [:from_acc, :to_acc]

  def build(%Account{} = from_account, %Account{} = to_account) do
    %__MODULE__{
      from_acc: from_account,
      to_acc: to_account
    }
  end
end
