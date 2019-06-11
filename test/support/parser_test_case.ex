defmodule Support.ParserTestCase do

  defmacro __using__(_options) do
    quote do
      use ExUnit.Case

      alias Earmark.Line
      alias Earmark.Options
      alias Earmark.Block
      alias Earmark.Parser

      import Support.Parser
    end
  end
  
end


# SPDX-License-Identifier: Apache-2.0
