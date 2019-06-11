defmodule Support.Parser do
  # def parse_lines lines do
  #   Earmark.Parser.parse(%Earmark.Options{}, lines, false)
  # end
  def lines_to_blocks(lines, options) do
    {blks, _links, opts} = Earmark.Parser.parse_lines(lines, options)
    {blks, opts}
  end

  def parse_markdown(lines, options \\ []) do
    {result, _} =
      Earmark.Parser.parse_markdown(lines, struct(Earmark.Options, options))
    case result do
      [%{lnb: 0} | rest] -> rest
      result1            -> result1
    end
  end
end

# SPDX-License-Identifier: Apache-2.0
