defmodule Acceptance.Lists.GfmSpecTest do
  use Support.AcceptanceTestCase

  describe "gfm lists: https://github.github.com/gfm/#lists" do
    test "debug" do
      html!("- a\n- b")
    end
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

    test "# 283" do
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

    test "# 284" do 
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

    test "# 285" do 
      markdown = """
      The number of windows in my house is
      1.  The number of doors is 6.
      """
      html = """
      <p>The number of windows in my house is</p>
      <ol>
      <li>The number of doors is 6.</li>
      </ol>
      """ |> String.replace(~r{\n}, "")
      assert html!(markdown) == html
    end

    test "# 286" do 
      markdown = """
      - foo

      - bar


      - baz
      """
      html = """
      <ul>
      <li>
      <p>foo</p>
      </li>
      <li>
      <p>bar</p>
      </li>
      <li>
      <p>baz</p>
      </li>
      </ul>
      """ |> String.replace(~r{\n}, "")
      assert html!(markdown) == html
    end

    test "# 287" do 
      markdown = """
      - foo
        - bar
          - baz


            bim
      """
      html = """
      <ul>
      <li>foo
      <ul>
      <li>bar
      <ul>
      <li>
      <p>baz</p>
      <p>bim</p>
      </li>
      </ul>
      </li>
      </ul>
      </li>
      </ul>

      """ |> String.replace(~r{\n}, "")
      assert html!(markdown) == html
    end

  end

end
