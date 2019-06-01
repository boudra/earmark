defmodule Earmark.Helpers.ListHelpers do
  alias Earmark.Error
  alias Earmark.Line

  @ul_item_header_rgx ~r<\A\s*([*+\-])\s+>
  @ol_item_header_rgx ~r<\A\s*(\d{1,9})([).])\s+>
  @doc false
  @spec calculate_list_indent( Line.t )::number
  def calculate_list_indent(line)
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

  
  defp _int_prefix_at(list, idx) do
    {number, _} =
      list
      |> Enum.at(idx)
      |> Integer.parse
    number
  end
end
