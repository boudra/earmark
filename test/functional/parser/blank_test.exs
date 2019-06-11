defmodule Functional.Parser.BlankTest do
  use Support.ParserTestCase
  
  test "blanks are included into AST" do
    actual_ast = parse_markdown("a\n\nb")
    expected_ast = [
      %Block.Para{attrs: nil, lines: ["a"], lnb: 1},
      %Block.Blank{lnb: 2},
      %Block.Para{attrs: nil, lines: ["b"], lnb: 3}]
    assert actual_ast == expected_ast
  end

  test "empty" do
    actual_ast = parse_markdown("")
    expected_ast = [ ]
    assert actual_ast == expected_ast
  end
end
