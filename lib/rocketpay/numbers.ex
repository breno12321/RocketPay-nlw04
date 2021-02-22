defmodule Rocketpay.Numbers do
  def sum_from_file(filename) do
    "#{filename}.csv"
    |> File.read()
    |> handle_file()
  end

  defp handle_file({:ok, file}) do
    file =
      file
      |> String.split(",")
      |> Stream.map(fn number -> String.to_integer(number) end)
      |> Enum.sum()

    {:ok, %{result: file}}
  end

  defp handle_file({:error, _reason}), do: {:error, %{message: "invalid file"}}
end
