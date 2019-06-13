defmodule Parser.WhitespaceTest do
  use Support.ParserTestCase

  test "Whitespace before and after code is ignored" do
    {result, _, _} = Parser.parse(["",
      "    line 1",
      "    line 2",
      "",
      "",
      "para"])

    expected = [
      %Block.Blank{},
      %Block.Blank{lnb: 1},
      %Block.Code{lnb: 2, attrs: nil,
        language: nil,
        lines: ["line 1", "line 2"]},
      %Block.Para{lnb: 6, attrs: nil, lines: ["para"]}
    ]
    assert result == expected
  end
end

# SPDX-License-Identifier: Apache-2.0
