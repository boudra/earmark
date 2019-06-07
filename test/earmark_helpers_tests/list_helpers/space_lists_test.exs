defmodule EarmarkHelpersTests.ListHelpers.SpaceListsTest do
  use ExUnit.Case
  import Earmark.Helpers.ListHelpers, only: [space_lists: 1]

  @one_input [
  :blank,
  %Earmark.Block.List{
    attrs: nil,
    blocks: [
      %Earmark.Block.ListItem{
        attrs: nil,
        blocks: [
          :blank,
          %Earmark.Block.Para{attrs: nil, lines: ["one"], lnb: 1}
        ],
        bullet: "-",
        bullet_type: "-",
        lnb: 1,
        spaced: true,
        type: :ul
      }
    ],
    bullet: "-, +, *, 1) or 2.",
    bullet_type: "-",
    lnb: 1,
    start: "",
    type: :ul
  },
  :blank
] 

  @one_output [
  :blank,
  %Earmark.Block.List{
    attrs: nil,
    blocks: [
      %Earmark.Block.ListItem{
        attrs: nil,
        blocks: [
          :blank,
          %Earmark.Block.Para{attrs: nil, lines: ["one"], lnb: 1}
        ],
        bullet: "-",
        bullet_type: "-",
        lnb: 1,
        spaced: false,
        type: :ul
      }
    ],
    bullet: "-, +, *, 1) or 2.",
    bullet_type: "-",
    lnb: 1,
    start: "",
    type: :ul
  },
  :blank
]
  test "one" do
    assert space_lists(@one_input) == @one_output
  end
end
