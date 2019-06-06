defmodule Acceptance.Lists.GfmSpecTest do
  use Support.AcceptanceTestCase

  describe "gfm lists: https://github.github.com/gfm/#lists" do
    test "# 281" do
      markdown = """
      - foo
      - bar
      + baz
      """
      html = """
      <ul>
      <li>foo</li>
      <li>bar</li>
      </ul>
      <ul>
      <li>baz</li>
      </ul>
      """ |> String.replace(~r{\s}, "")
      assert html!(markdown) == html 
    end

    test "# 282" do
      markdown = """
      1. foo
      2. bar
      3) baz
      """
      html = """
      <ol>
      <li>foo</li>
      <li>bar</li>
      </ol>
      <ol start="3">
      <li>baz</li>
      </ol>
      """ |> String.replace(~r{\n}, "")
      assert html!(markdown) == html
      
    end
  end
  
end
