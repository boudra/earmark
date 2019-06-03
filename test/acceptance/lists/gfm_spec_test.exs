defmodule Acceptance.Lists.GfmSpecTest do
  use Support.AcceptanceTestCase

  describe "Simple cases" do
    test "parses" do
      markdown = """
      # Hello World
      
      * one
      * two
      """
      html = "<h1>Hello World</h1><ul><li>one</li><li>two</li></ul>"
      assert html!(markdown) == html 
    end

    test "simple case" do
      markdown = """
      * one
      """
      html = "<ul><li>one</li></ul>"
      assert html!(markdown) == html 
    end
  end
  
end
