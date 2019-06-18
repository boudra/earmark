defmodule Dev.Debugging do


  def line(line, options \\ []) do
    Earmark.Line.type_of({line, 0}, struct(Earmark.Options, options), false)
  end

  def print_html(markdown) do
    markdown
    |> Earmark.as_html!
    |> IO.puts
  end

  def parse(markdown) do
    Earmark.Parser.parse_markdown(markdown)
    |> IO.inspect
    # |> remove_context()
  end

  def duplicate(something), do: {something, something}

  def nth(something, n) do
    {something, _nth(something, n)}
  end

  def debug(object, title \\ nil) do
    if System.get_env("DEBUG") do
      _debug(object, title)
    else
      object
    end
  end

  defp _debug({:__debug__, original, part}, title) do
    if title do
      IO.puts :stderr, ">>> #{title}"
    end
    IO.puts(:stderr, 
      inspect(part, pretty: true))
    if title do
      IO.puts :stderr, "<<< #{title}"
    end
    original
  end
  defp _debug(other, title) do
    _debug({:__debug__, other, other}, title)
  end

  def inspect_only({original, collection}, elements) do
    {original,
      collection
      |> Enum.map(only(elements))
      |> IO.inspect
    }
  end
  def inspect_only(collection, elements) do
    collection
      |> Enum.map(only(elements))
      |> IO.inspect
    collection
  end

  def ret({original, _}), do: original

  def only(elements) do
    fn a_map ->
      Map.take(a_map, [:__struct__ | elements])
    end
  end

  defp _nth(something, n)
  defp _nth(tuple, n) when is_tuple(tuple) do
    _nth(Tuple.to_list(tuple), n)
  end
  defp _nth(list, n) when is_list(list) do
    Enum.at(list, n)
  end

end
