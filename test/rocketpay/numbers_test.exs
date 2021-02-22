defmodule Rocketpay.NumbersTest do
  use ExUnit.Case

  alias Rocketpay.Numbers

  describe "sum_from_file/1" do
    test "Should sum numbers from csv file" do
      response = Numbers.sum_from_file("numbers")

      expected_response = {:ok, %{result: 37}}

      assert response == expected_response
    end

    test "Should return error from csv file that doesn't exist" do
      response = Numbers.sum_from_file("banana")

      expected_response = {:error, %{message: "invalid file"}}

      assert response == expected_response
    end
  end
end
