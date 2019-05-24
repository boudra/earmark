defmodule Acceptance.Lists.GfmTest do
  use Support.AcceptanceTestCase

  describe "List Items: https://github.github.com/gfm/#list-items" do
    test "Example 232 https://github.github.com/gfm/#example-232" do
      markdown = """
                 1.  A paragraph
                 with two lines.

                     indented code

                 > A block quote.
                 """ |> String.trim_trailing("\n")

      html = """
             <ol>
             <li><p>A paragraph
             with two lines.</p>
             <pre><code>indented code
             </code></pre>
             <blockquote>
             <p>A block quote.</p>
             </blockquote>
             </li>
             </ol>
              """ |> String.trim_trailing("\n")

      messages = []

      assert as_html(markdown) == {:ok, html, messages}
    end

    test "Example 233 https://github.github.com/gfm/#example-233" do
      markdown = " - one

   two"

      html = """
             <ul>
             <li>one
             </li>
             </ul>
             <p> two</p>
              """

      messages = []

      assert as_html(markdown) == {:ok, html, messages}
    end
    
    test "Example 234 https://github.github.com/gfm/#example-234" do
      markdown = "- one

    two"

      html = """
             <ul>
             <li><p>one</p>
             <p>two</p>
             </li>
             </ul>
             """

      messages = []

      assert as_html(markdown) == {:ok, html, messages}
    end


    test "Example 235 https://github.github.com/gfm/#example-235" do
      markdown = " -    one

       two"

       html = """
              <ul>
              <li>one</li>
              </ul>
              <pre><code> two
              </code></pre>
              """

      messages = []

      assert as_html(markdown) == {:ok, html, messages}
    end


    test "Example 236 https://github.github.com/gfm/#example-236" do
      markdown = " -    one

        two"

      html =  """
              <ul>
              <li><p>one</p>
              <p>two</p>
              </li>
              </ul>
              """

      messages = []

      assert as_html(markdown) == {:ok, html, messages}
    end
  end
end
