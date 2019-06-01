defmodule Earmark.Helpers.LookaheadHelpers do
  use Earmark.Types

  alias Earmark.Line
  import Earmark.Helpers.LineHelpers
  import Earmark.Helpers.LeexHelpers
  import Earmark.Helpers.ListHelpers

  @doc """
  Indicates if the _numbered_line_ passed in leaves an inline code block open.

  If so returns a tuple whre the first element is the opening sequence of backticks,
  and the second the linenumber of the _numbered_line_

  Otherwise `{nil, 0}` is returned
  """
  def opens_inline_code(%{line: line, lnb: lnb}) do
    case tokenize(line, with: :string_lexer) |> has_still_opening_backtix(nil) do
      nil -> {nil, 0}
      {_, btx} -> {btx, lnb}
    end
  end

  @doc """
  returns false if and only if the line closes a pending inline code
  *without* opening a new one.
  The opening backtix are passed in as second parameter.
  If the function does not return false it returns the (new or original)
  opening backtix
  """
  # (#{},{_,_}) -> {_,_}
  def still_inline_code(%{line: line, lnb: lnb}, old = {pending, _pending_lnb}) do
    case tokenize(line, with: :string_lexer) |> has_still_opening_backtix({:old, pending}) do
      nil -> {nil, 0}
      {:new, btx} -> {btx, lnb}
      {:old, _} -> old
    end
  end

  # A tokenized line {:verabtim, text} | {:backtix, ['``+]} is analyzed for
  # if it is closed (-> nil), not closed (-> {:old, btx}) or reopened (-> {:new, btx})
  # concerning backtix
  defp has_still_opening_backtix(tokens, opened_so_far)

  # Empty, done, but take care of tangeling escape (\)
  defp has_still_opening_backtix([], :force_outside), do: nil
  defp has_still_opening_backtix([], open), do: open

  # Outside state, represented by nil
  defp has_still_opening_backtix([{:other, _} | rest], nil),
    do: has_still_opening_backtix(rest, nil)

  defp has_still_opening_backtix([{:backtix, btx} | rest], nil),
    do: has_still_opening_backtix(rest, {:new, btx})

  defp has_still_opening_backtix([{:escape, _} | rest], nil),
    do: has_still_opening_backtix(rest, :force_outside)

  # Next state forced outside, represented by :force_outside
  defp has_still_opening_backtix([_ | rest], :force_outside),
    do: has_still_opening_backtix(rest, nil)

  # Inside state, represented by { :old | :new, btx }
  defp has_still_opening_backtix([{:backtix, btx} | rest], open = {_, openedbtx}) do
    if btx == openedbtx do
      has_still_opening_backtix(rest, nil)
    else
      has_still_opening_backtix(rest, open)
    end
  end

  defp has_still_opening_backtix([_ | rest], open = {_, _}),
    do: has_still_opening_backtix(rest, open)

  #######################################################################################
  # read_list_lines
  #######################################################################################
  @type read_list_info :: %{
          bullet: String.t,
          pending: maybe(String.t),
          pending_lnb: number,
          initial_indent: number,
          type: :ul | :ol
        }
  @doc """
  Called to slurp in the lines for a list item.
  basically, we allow indents and blank lines, and
  we allow text lines only after an indent (and initially)
  We also slurp in lines that are inside a multiline inline
  code block as indicated by `pending`.
  """
  def read_list_lines([first|lines]) do
    {pending, pending_lnb} = opens_inline_code(first)
    indent = calculate_list_indent(first)
    {bullet, type, start} = determine_list_type(first)
    _read_list_lines(lines, [], %{
      bullet: bullet,
      pending: pending,
      pending_lnb: pending_lnb,
      initial_indent: indent
    }) |> Dev.Debugging.nth(1)
      |> Dev.Debugging.inspect("--- Read List Lines")
  end

  defp _read_spaced_list_lines(lines, result, paras)
  defp _read_spaced_list_lines(lines, result, _params) do
    {true, Enum.reverse(result), lines}
  end

  defp _read_list_lines([%Line.Blank{} | rest], result, params) do
    # Behavior which lines are contained in the list changes dramatically after
    # the first blank line.
    _read_spaced_list_lines(rest, [""|result], params)
  end
  # Same list type, continue slurping...
  defp _read_list_lines(
         [ %Line.ListItem{bullet: new_bullet, line: line} | rest],
         result,
         params = %{bullet: old_bullet, pending: nil}
       )
       when new_bullet == old_bullet do
    with {pending1, pending_lnb1} = opens_inline_code(line),
         do:
           _read_list_lines(rest, [line | result], %{
             params
             | pending: pending1,
               pending_lnb: pending_lnb1
           })
  end
  # Not the same list type, we are done
  defp _read_list_lines(
         [ %Line.ListItem{} | _] = rest,
         result,
         _params
       )
       do
         {false, Enum.reverse(result), rest}
  end
  # Rulers end lists too
  defp _read_list_lines(
         [ %Line.Ruler{} | _] = rest,
         result,
         _params
       ) do
         {false, Enum.reverse(result), rest}
  end
  # Other text needs slurping...
  defp _read_list_lines([%{line: line} | rest], result, params = %{pending: nil}) do
    with {pending1, pending_lnb1} = opens_inline_code(line),
         do:
           _read_list_lines(rest, [line | result], %{
             params
             | pending: pending1,
               pending_lnb: pending_lnb1
           })
    _read_list_lines(rest, [line], _opens_inline_code(line, params))
  end

  # Only now we match for list lines inside an open multiline inline code block
  defp _read_list_lines(
         [line | rest],
         result,
         params = %{pending: pending, pending_lnb: pending_lnb}
       ) do
    with {pending1, pending_lnb1} = still_inline_code(line, {pending, pending_lnb}),
      do:
        _read_list_lines(rest, [%{line | inside_code: true} | result], %{
          params
          | pending: pending1,
            pending_lnb: pending_lnb1
        })
  end

  # Running into EOI insise an open multiline inline code block
  defp _read_list_lines([], result, params = %{pending_lnb: pending_lnb, min_indent: min_indent}) do
    {spaced, rest, lines, _, _} = _read_list_lines([], result, %{params | pending: nil})
    {spaced, rest, lines, pending_lnb, min_indent}
  end

  defp _remove_trailing_blanks(lines, result) do
    {trailing_blanks, rest} = Enum.split_while(result, &blank?/1)
    spaced = length(trailing_blanks) > 0
    {spaced, Enum.reverse(rest), lines}
  end

  defp new_min_indent(nil, new_min_indent), do: new_min_indent

  defp new_min_indent(old_min_indent, new_min_indent) when old_min_indent <= new_min_indent,
    do: old_min_indent

  defp new_min_indent(_, new_min_indent), do: new_min_indent

  # Convenience wrapper around `opens_inline_code` into a map
  defp _opens_inline_code(line, params) do
    with {pending, pending_lnb} = opens_inline_code(line),
      do: %{params | pending: pending, pending_lnb: pending_lnb}
  end
end

# SPDX-License-Identifier: Apache-2.0
