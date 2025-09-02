# NUWA.NVIM :package: :swan:

***A light Neovim package manager. :package: :swan:***

## USAGE

```Lua
local nuwaPath = vim.fn.stdpath("data") .. "/nuwa"
local nuwaRepo = "https://github.com/alyxshang/nuwa.nvim.git"
vim.fn.system(
  {
    "git", 
    "clone", 
    "--depth=1", 
    nuwaRepo,
    nuwaPath
  }
)
local nuwaPkgPath = vim.fn.stdpath("data") .. "/nuwaPkgs"
vim.opt.rtp:prepend(nuwaPath)
local nuwa = require("nuwa")
nuwa.setup()
nuwa.installPackage(
  "https://github.com",
  "alyxshang",
  "emeraldsparrow.nvim"
)
require("emeraldsparrow").setup(
  {
    transparent = false
  }
)
vim.cmd.colorscheme("emeraldsparrow")
```
