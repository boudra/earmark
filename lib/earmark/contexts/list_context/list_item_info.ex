defmodule Earmark.Contexts.ListContext.ListItemInfo do

  alias Earmark.Block
  alias Earmark.Contexts.ListContext.ListInfo

  @moduledoc """
  Augements `Block.ListItem` with info needed for parsing.
  """
  defstruct [
    indent: 0,
    list_indent: 0,
    list_info: %ListInfo{},
    list_item: %Block.ListItem{},
  ]
end
