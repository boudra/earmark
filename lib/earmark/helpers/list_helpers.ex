defmodule Earmark.Helpers.ListHelpers do

  alias Earmark.Error
  alias Earmark.Line
  alias Earmark.Block

  @ul_item_header_rgx ~r<\A\s*([*+\-])\s+>
  @ol_item_header_rgx ~r<\A\s*(\d{1,9})([).])\s+>
  @doc false
  @spec calculate_list_indent( Line.t )::number
  def calculate_list_indent(line)
  def calculate_list_indent(line) when is_binary(line) do
    calculate_list_indent(%{line: line})
  end
  def calculate_list_indent(%{line: content}=line) do
    cond do
      match = Regex.run(@ul_item_header_rgx, content) -> match |> hd() |> String.length
      match = Regex.run(@ol_item_header_rgx, content) -> match |> hd() |> String.length
      true                                   -> raise Error, "Internal Call error, not a list item #{inspect line}"
    end
  end

  @doc false
  def determine_list_type(line)
  def determine_list_type(%{line: content}=line) do
    cond do
      match = Regex.run(@ul_item_header_rgx, content) -> {match |> Enum.at(1), :ul, 0}
      match = Regex.run(@ol_item_header_rgx, content) -> {match |> Enum.at(2), :ol, match |> _int_prefix_at(1)} 
      true                                   -> raise Error, "Internal Call error, not a list item #{inspect line}"
    end
  end

  @doc false
  def space_lists(blocks)
  def space_lists(blocks) do
    IO.inspect blocks
    Enum.map(blocks, &space_list/1)
  end

  defp space_list(block)
  defp space_list(%Block.List{blocks: blocks} = list) do
    %{list | blocks: space_lists(blocks)}
  end
  defp space_list(%{spaced: _}=block) do
    %{block | spaced: false}
  end
  defp space_list(block) do
    block
  end

  defp list_spaced?(blocks) do
    _list_spaced?(blocks, :init)
  end

  defp _list_spaced?(blocks, state)
  defp _list_spaced?([], _), do: false
  defp _list_spaced?([:blank|rest], :init) do
    _list_spaced?(rest, :init)
  end
  defp _list_spaced?([_|rest], :init) do
    _list_spaced?(rest, :candidate)
  end
  defp _list_spaced?([:blank|rest], :candidate) do
    _list_spaced?(rest, :spaced)
  end
  defp _list_spaced?([_|rest], :candidate) do
    _list_spaced?(rest, :candidate)
  end
  defp _list_spaced?([:blank|rest], :spaced) do
    _list_spaced?(rest, :spaced)
  end
  defp _list_spaced?([_|rest], :spaced) do
    true
  end

  
  defp _int_prefix_at(list, idx) do
    {number, _} =
      list
      |> Enum.at(idx)
      |> Integer.parse
    number
  end
end
