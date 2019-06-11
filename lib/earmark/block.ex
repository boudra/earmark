defmodule Earmark.Block do

  # import Tools.Tracer
  use Earmark.Types
  import Earmark.Helpers.LookaheadHelpers, only: [opens_inline_code: 1, still_inline_code: 2, read_list_lines: 3]
  import Earmark.Helpers.LineHelpers
  import Earmark.Helpers.AttrParser
  import Earmark.Helpers.ReparseHelpers
  import Earmark.Message, only: [add_message: 2, add_messages: 2]

  @moduledoc """
  Given a list of parsed lines, convert them into blocks.
  That list of blocks is the final representation of the
  document (in internal form).
  """

  alias Earmark.Line
  alias Earmark.Parser
  alias Earmark.Options

  defmodule Heading,     do: defstruct lnb: 0, attrs: nil, content: nil, level: nil
  defmodule Ruler,       do: defstruct lnb: 0, attrs: nil, type: nil
  defmodule BlockQuote,  do: defstruct lnb: 0, attrs: nil, blocks: []
  defmodule Para,        do: defstruct lnb: 0, attrs: nil, lines:  []
  defmodule Code,        do: defstruct lnb: 0, attrs: nil, lines:  [], language: nil
  defmodule Html,        do: defstruct lnb: 0, attrs: nil, html:   [], tag: nil
  defmodule HtmlOther,   do: defstruct lnb: 0, attrs: nil, html:   []
  defmodule IdDef,       do: defstruct lnb: 0, attrs: nil, id: nil, url: nil, title: nil
  defmodule FnDef,       do: defstruct lnb: 0, attrs: nil, id: nil, number: nil, blocks: []
  defmodule FnList,      do: defstruct lnb: 0, attrs: ".footnotes", blocks: []
  defmodule Ial,         do: defstruct lnb: 0, attrs: nil, content: nil, verbatim: ""
  # List does not need line number
  defmodule List,        do: defstruct lnb: 1, attrs: nil, type: :ul, blocks:  [], start: ""
  defmodule ListItem,    do: defstruct lnb: 0, attrs: nil, type: :ul, spaced: true, blocks: [], bullet: ""

  defmodule Plugin,      do: defstruct lnb: 0, attrs: nil, lines: [], handler: nil, prefix: "" # prefix is appended to $$

  defmodule Table do
    defstruct lnb: 0, attrs: nil, rows: [], header: nil, alignments: []

    def new_for_columns(n) do
      %__MODULE__{alignments: Elixir.List.duplicate(:left, n)}
    end
  end

  @type t :: %Heading{} | %Ruler{} | %BlockQuote{} | %List{} | %ListItem{} | %Para{} | %Code{} | %Html{} | %HtmlOther{} | %IdDef{} | %FnDef{} | %FnList{} | %Ial{} | %Table{}
  @type ts :: list(t)
end

# SPDX-License-Identifier: Apache-2.0
