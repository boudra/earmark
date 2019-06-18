defmodule Earmark.Contexts.ParserContext.ListParser do

  alias Earmark.Block
  alias Earmark.Line
  alias Earmark.Options
  alias Earmark.Contexts.ListContext.ListInfo
  alias Earmark.Contexts.ListContext.ListItemInfo

  import Earmark.Contexts.ListContext.ListHelpers, only: [calculate_list_indent: 1, extract_start: 1]
  import Earmark.Contexts.StringContext,  only: [behead_indent: 2]
  import Earmark.Helpers.InlineCodeHelpers, only: [opens_inline_code: 1, still_inline_code: 2]
  import Earmark.Message, only: [add_message: 2]

  @moduledoc """
  Parse list items into a list
  """

  @doc """
  Parse all lines corresponding to the list
  """
  def parse_list(lines, result, options \\ %Options{})
  def parse_list(lines, result, options) do
    {list, rest, options1} = _parse_list(lines, _make_list_info(lines), options)
    {[list|result], rest, options1}
  end

  defp _parse_list(lines, list_info, options)
  defp _parse_list([item|rest], list_info, options) do
    {list_item, rest, options1} = _parse_list_item(rest, _make_list_item_info(item, list_info), options)
    list_info1 = _add_list_item_to_list_info(list_item, list_info)
    case _list_continuation_type(rest, list_info1) do
      :same -> _parse_list(rest, list_info1, options1)
      _    -> {list_info.list, rest, options1}
    end
  end

  defp _parse_list_item(lines, list_item_info, options)
  defp _parse_list_item([%Line.Blank{}|rest], list_item_info, options) do
    _parse_list_item_body(rest, _add_to_list_item_head("", list_item_info), options)
  end
  defp _parse_list_item([%Line.ListItem{}=item|rest], list_item_info, options) do
    case _list_item_head_continuation(item, list_item_info) do
      :inner -> _continue_parse_list_item([item|rest], list_item_info, options)
      :next  -> {list_item_info.list_item, [item|rest], options}
      _      -> _parse_list_item(rest, _add_content_to_list_item_info(item, list_item_info), options)
    end
  end
  defp _parse_list_item([item|rest], list_item_info, options) do
    list_item_info1 = _add_content_to_list_item_info(item, list_item_info)
    _parse_list_item(rest, list_item_info1, options)
  end
  defp _parse_list_item([], list_item_info, options) do
    {list_item_info.list_item, [], options}
  end

  # We descend into the next list
  defp _continue_parse_list_item(lines, list_item_info, options) do
    {[list], rest, options1} = parse_list(lines, [], options)
    list_item_info1 = _add_to_list_item_blocks(list, list_item_info)
    _parse_list_item(rest, list_item_info1, options1)
  end

  @not_pending {nil, 0}
  #
  # Helpers in alphabetical order
  # =============================
 
  defp _add_content_to_list_item_info(%{content: content}, %{list_item: list_item} = list_item_info) do
    [para|rest] = list_item.blocks
    para1 = %{para | lines: [content | para.lines]}
    %{list_item_info | list_item: %{list_item | blocks: [para1|rest]}}
  end


  defp _add_list_item_to_list_info(list_item, %ListInfo{list: list}=list_info) do
    %{list_info | list: %{list | blocks: [list_item | list.blocks]}}
  end

  defp _list_item_head_continuation(item, list_item_info) do
    cond do
      item.indent > list_item_info.list_info.list.indent + 3 -> :head # c.f. https://github.github.com/gfm/#example-292
      item.indent >= list_item_info.list_indent              -> :inner
      true                                                   -> :next 
    end
  end
  # defp _add_to_first_block(blocks, item)
  # defp _add_to_first_block([%{blocks: blocks}=first|rest], item) do
  #   [%{first | blocks: [item|blocks]}]
  # end

  # defp _make_list(_list_info, items) do

  #   %Block.List{blocks: items}
  # end

  defp _list_continuation_type(lines, info)
  defp _list_continuation_type([%{bullet: bullet} = item|_], %ListItemInfo{list_info: list_info, list_item: %{bullet: bullet}}=list_item_info) do
    _list_cont_type_same(item, list_info.indent, list_info.list_indent, list_item_info.indent, list_item.list_indent)
  end
  defp _list_cont_type_same(_, _), do: :next

  defp _list_cont_type_same(%{indent: i, list_indent: li}, indent, list_indent, li_indent, li_list_indent) do
    if i > 
  end

  defp _make_list_info(%Line.ListItem{}=item) do
    list =  %Block.List{
      bullet: item.bullet,
      bullet_type: item.bullet_type,
      lnb: item.lnb}
    %ListInfo{
      list: list,
      indent: item.initial_indent,
      list_indent: calculate_list_indent(item),
      pending: opens_inline_code(item),
    }
    # list = %Block.List{
    #   blocks: [list_item],
    #   bullet: item.bullet,
    #   bullet_type: item.bullet_type,
    #   lnb: item.lnb,
    #   start: extract_start(item),
    #   type: item.type,
    # }
  end

  defp _make_list_item_info(%Line.ListItem{}=item, %ListInfo{}=list_info) do
    list_item =
      %Block.ListItem{
        blocks: [%Block.Para{lines: [item.content], loose: false, lnb: item.lnb}],
        bullet: item.bullet,
        bullet_type: item.bullet_type,
        lnb: item.lnb,
      }
    %ListItemInfo{
      indent: item.initial_indent,
      list_indent: calculate_list_indent(item),
      list_info: list_info,
      list_item: list_item,
    }
  end
end
