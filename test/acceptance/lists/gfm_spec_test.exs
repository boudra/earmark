defmodule Acceptance.Lists.GfmSpecTest do
  use Support.AcceptanceTestCase

  describe "gfm lists: https://github.github.com/gfm/#lists" do
    test "debug" do
      html!("- a\n\n- b")
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

    test "# 288" do
      markdown = """
      - foo
      - bar

      <!-- -->

      - baz
      - bim
      """
      html = """
      <ul>
      <li>foo</li>
      <li>bar</li>
      </ul>
      <!-- -->
      <ul>
      <li>baz</li>
      <li>bim</li>
      </ul>
      """ |> String.replace(~r{\n}, "")
      assert html!(markdown) == html
    end

    # Quite special case, too early to estimate the necessary
    # effort for implementation
    @tag :later
    test "# 289" do
      markdown = """
      -   foo

          notcode

      -   foo

      <!-- -->

          code
      """
      html = """
      <ul>
      <li>
      <p>foo</p>
      <p>notcode</p>
      </li>
      <li>
      <p>foo</p>
      </li>
      </ul>
      <!-- -->
      <pre><code>code
      </code></pre>
      """ |> String.replace(~r{\n}, "")
      assert html!(markdown) == html
    end

    test "# 290" do
      markdown = """
      - a
       - b
        - c
         - d
        - e
       - f
      - g
      """
      html = """
      <ul>
      <li>a</li>
      <li>b</li>
      <li>c</li>
      <li>d</li>
      <li>e</li>
      <li>f</li>
      <li>g</li>
      </ul>
      """ |> String.replace(~r{\n}, "")
      assert html!(markdown) == html
    end

    test "# 291" do
      markdown = """
      1. a

        2. b

         3. c
      """
      html = """
      <ol>
      <li>
      <p>a</p>
      </li>
      <li>
      <p>b</p>
      </li>
      <li>
      <p>c</p>
      </li>
      </ol>
      """ |> String.replace(~r{\n}, "")
      assert html!(markdown) == html
    end

    # To implement this spec we need to rethink how to reparse list items' content as
    # we clearly need knowledge about the indent of "- a" when deciding if "    - e" is a
    # continuation of the list, however we do this inside `read_list_lines`, during
    # the reparsing of "- e" (no more leading spaces).
    @tag :later
    test "# 292" do
      markdown = """
      - a
       - b
        - c
         - d
          - e
      """
      html = """
      <ul>
      <li>a</li>
      <li>b</li>
      <li>c</li>
      <li>d
      - e</li>
      </ul>
      """ |> String.replace(~r{\n}, "")
      assert html!(markdown) == html
    end

    # Idem
    @tag :later
    test "# 293" do
      markdown = """
      1. a

        2. b

         3. c
      """
      html = """
      <ol>
      <li>
      <p>a</p>
      </li>
      <li>
      <p>b</p>
      </li>
      </ol>
      <pre><code>3. c
      </code></pre>
      """ |> String.replace(~r{\n}, "")
      assert html!(markdown) == html
    end

    # 294 is really the same as 286

    # Do empty list items make a lot of sense?
    @tag :later
    test "# 295" do
      markdown = """
      * a
      *

      * c
      """
      html = """
      <ul>
      <li>
      <p>a</p>
      </li>
      <li></li>
      <li>
      <p>c</p>
      </li>
      </ul>
      """ |> String.replace(~r{\n}, "")
      assert html!(markdown) == html
    end

    test "# 296" do
      markdown = """
      - a
      - b

        c
      - d
      """
      html = """
      <ul>
      <li>
      <p>a</p>
      </li>
      <li>
      <p>b</p>
      <p>c</p>
      </li>
      <li>
      <p>d</p>
      </li>
      </ul>
      """ |> String.replace(~r{\n}, "")
      assert html!(markdown) == html
    end

    test "# 297" do
      markdown = """
      - a
      - b

        [ref]: /url
      - d
      """
      html = """
      <ul>
      <li>
      <p>a</p>
      </li>
      <li>
      <p>b</p>
      </li>
      <li>
      <p>d</p>
      </li>
      </ul>
      """ |> String.replace(~r{\n}, "")
      assert html!(markdown) == html
    end

    test "# 298" do
      markdown = """
      - a
      - ```
        b


        ```
      - c
      """
      html = """
      <ul>
      <li>a</li>
      <li>
      <pre><code>b


      </code></pre>
      </li>
      <li>c</li>
      </ul>
      """ |> String.replace(~r{\n}, "")
      assert html!(markdown) == html
    end

    test "# 304" do
      markdown = """
      1. ```
         foo
         ```

         bar
      """
      html = """
      <ol>
      <li>
      <pre><code>foo
      </code></pre>
      <p>bar</p>
      </li>
      </ol>
      """ |> String.replace(~r{\n}, "")
      assert html!(markdown) == html
    end

  end

end
