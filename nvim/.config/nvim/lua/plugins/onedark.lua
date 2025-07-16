-- lua/plugins/onedark.lua

return {
  "navarasu/onedark.nvim",
  priority = 1000,
  config = function()
    require("configs.onedark").setup()
  end,
}

