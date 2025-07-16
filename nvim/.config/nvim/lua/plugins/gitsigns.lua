-- -- Adds git-related signs to the gutter, as well as utilities for managing changes
-- return {
--   'lewis6991/gitsigns.nvim',
--   opts = {
--     -- See `:help gitsigns.txt`
--     signs = {
--       add          = { text = '' },  -- plus-square
--       change       = { text = '' },  -- modified-square
--       delete       = { text = '' },  -- minus-square
--       topdelete    = { text = '󰍶' },  -- arrow pointing up
--       changedelete = { text = '󱕖' },  -- combined change/delete (as per your example)
--     },
--     signs_staged = {
--       add          = { text = '' },  -- circle-plus
--       change       = { text = '' },  -- filled circle
--       delete       = { text = '' },  -- circle-minus
--       topdelete    = { text = '󰳞' },  -- upward-triangle
--       changedelete = { text = '󱕘' },  -- alternative combined icon
--     },
--     sign_priority = 10,
--   },
-- }


-- Adds git related signs to the gutter, as well as utilities for managing changes
return {
  'lewis6991/gitsigns.nvim',
  opts = {
    -- See `:help gitsigns.txt`
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    signs_staged = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    sign_priority = 10,
  },
}
