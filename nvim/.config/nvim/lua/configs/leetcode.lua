local options = {
  lang = "python3",
  image_support = false,
  logging = true,
  storage = {
    home = vim.fn.getcwd(),
    cache = vim.fn.stdpath "cache" .. "/leetcode",
  },
  plugins = {
    non_standalone = true,
  },
  injector = {
    ["python3"] = {
      before = true,
    },
    ["cpp"] = {
      before = { "#include <bits/stdc++.h>", "using namespace std;" },
      after = "int main() {}",
    },
    ["java"] = {
      before = "import java.util.*;",
    },
  },
  keys = {
    toggle = { "q" }, ---@type string|string[]
    confirm = { "<CR>" }, ---@type string|string[]

    reset_testcases = "r", ---@type string
    use_testcase = "U", ---@type string
    focus_testcases = "H", ---@type string
    focus_result = "L", ---@type string
  },
}

require("leetcode").setup(options)
