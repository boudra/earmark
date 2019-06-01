defmodule Support.Floki do

  
  def nodes(markdown, options \\ []) do
    Support.Helpers.as_html(markdown, options)
    |> Floki.parse
  end
end
