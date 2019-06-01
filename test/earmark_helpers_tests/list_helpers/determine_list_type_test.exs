defmodule EarmarkHelpersTests.ListHelpers.DetermineListTypeTest do
  use ExUnit.Case

  describe "ul" do
    test "bare -" do
      assert result("- ") == {"-", :ul, 0}
    end
    test "suffixed +" do
      assert result("+  hello") == {"+", :ul, 0}
    end
    test "prefixed *" do
      assert result(" * world") == {"*", :ul, 0} 
    end
    test "more spaces" do
      assert result("  -  Universe") == {"-", :ul, 0} 
    end
  
  end

  describe "ol" do
    test "left" do
      assert result("0. ") == {".", :ol, 0} 
    end

    test "middle" do
      assert result("  23)  x") == {")", :ol, 23}
    end

    test "right" do
      assert result(" 1. 2") == {".", :ol, 1} 
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
    Earmark.Helpers.ListHelpers.determine_list_type(%{line: str})
  end
  
  defp result_fn(str) do
    fn -> result(str) end
  end
end
