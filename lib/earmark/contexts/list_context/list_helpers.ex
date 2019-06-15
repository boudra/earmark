defmodule Earmark.Contexts.ListContext.ListHelpers do

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
  def tighten_lists(blocks)
  def tighten_lists(blocks) do
    Enum.map(blocks, &tighten_list/1)
  end

  defp tighten_list(block)
  defp tighten_list(%Block.List{blocks: blocks} = list) do
    # tight = Enum.any?(blocks, &_list_item_tight?(&1.blocks, :init))
    tight = Enum.any?(blocks, &_list_item_tight?/1)
    blocks1 = Enum.map(blocks, &%{&1  | tight: tight})
    %{list | blocks: tighten_lists(blocks1)}
  end
  defp tighten_list(%{blocks: blocks} = list) do
    %{list | blocks: tighten_lists(blocks)}
  end
  defp tighten_list(block) do
    block
  end

  defp _list_item_tight?(block)
  defp _list_item_tight?(%Block.ListItem{tight: true}), do: true
  defp _list_item_tight?(_), do: false

  
  defp _int_prefix_at(list, idx) do
    {number, _} =
      list
      |> Enum.at(idx)
      |> Integer.parse
    number
  end
end
