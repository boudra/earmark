defmodule EarmarkHelpersTests.ListHelpers.CalculateListIndentTest do
  use ExUnit.Case

  describe "ul" do
    test "bare -" do
      assert result("- ") == 2
    end
    test "suffixed +" do
      assert result("+  hello") == 3
    end
    test "prefixed *" do
      assert result(" * world") == 3
    end
    test "more spaces" do
      assert result("  -  Universe") == 5
    end
  
  end

  describe "ol" do
    test "left" do
      assert result("0. ") == 3
    end

    test "middle" do
      assert result("  23.  x") == 7
    end

    test "right" do
      assert result(" 1) 2") == 4
    end
  end

  describe "error case" do
    test "no list" do
      assert_raise(Earmark.Error, result_fn(""))
    end
    test "too many digits" do
      assert_raise(Earmark.Error, result_fn(" 1234567890. hello"))
    end
  end


  defp result(str) do
    Earmark.Helpers.ListHelpers.calculate_list_indent(%{line: str})
  end
  
  defp result_fn(str) do
    fn -> result(str) end
  end

end
