defmodule Acceptance.Lists.GfmSpecTest do
  use Support.AcceptanceTestCase

  describe "first goes with floki" do
    test "parses" do
      markdown = """
      # Hello World
      
      * one
      * two
      """
      assert nodes(markdown) == []
    end
  end
  
end
