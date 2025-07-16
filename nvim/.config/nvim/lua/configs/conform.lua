local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "mdformat", "prettier" },
    sh = { "shfmt" },
    toml = { "taplo" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    python = { "black" }, -- or { "black", "isort" }
    go = { "gofmt" },
    rust = { "rustfmt" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}
return options

