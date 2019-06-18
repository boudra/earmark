defmodule Earmark.Contexts.ListContext.ListInfo do

  alias Earmark.Block

  @moduledoc """
  Augements `Block.List` with info needed for parsing.
  """
  defstruct [
    list: %Block.List{},
    # defmodule List,        do: defstruct lnb: 1, attrs: nil, type: :ul, blocks:  [], start: "", bullet: "-, +, *, 1) or 2.", bullet_type: "-, +, *, . or )"
    pending: {nil, 0}, # or { "`", 42}
    indent: 0,      # "  1. a" --> 2
    list_indent: 0, # "  1. a" --> 5
    loose?: false,
    trailing_blanks?: false,
  ]
end
