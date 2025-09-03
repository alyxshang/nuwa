# NUWA.NVIM :package: :swan:

***A light Neovim package manager. :package: :swan:***

## ABOUT :books:

This repository contains the Lua source code for an extremely light
package manager for Neovim. The package manager is named after the
Chinese goddess of creation ***Nuwa (女媧)***.

## FEATURES :test_tube:

- Auto-updates every single plugin as soon as one enters Neovim.
- Auto-updates the package manager as one enters Neovim.
- Allows one to manually delete a plugin with the `NuwaDelete` command.
- Gives the user full control over how one wants to add or install plugins.
- Extremely light (<200 LOC).

## INSTALLATION :inbox_tray:

***Nuwa*** requires the `git` command to be available from 
the command line. To install ***Nuwa***, add these lines to 
your `init.lua`, the Lua configuration file for Neovim. It is 
strongly recommended to wrap this snippet into a function and call 
this function before installing a package. The code in this snippet 
will download this repository, place it into Neovim's `data` directory, 
and add the path of the repository to Neovim's runtime path.

```Lua
local nuwaPath = vim.fn.stdpath("data") .. "/nuwa"
vim.fn.system(
  {
    "git", 
    "clone", 
    "--depth=1", 
    "https://github.com/alyxshang/nuwa.nvim.git",
    nuwaPath
  }
)
vim.opt.rtp:prepend(nuwaPath)
```

## USAGE :hammer_and_pick:

The code snippet below illustrates how to load ***Nuwa*** itself,
install a package, and load the package. The section below this code
snippet explains usage of ***Nuwa*** further.

```Lua
-- Declare the "nuwa" module.
local nuwa = require("nuwa")

-- Run the "nuwa" setup
-- function.
nuwa.setup()

-- Install a package.
nuwa.installPackage(
  "https://github.com",
  "alyxshang",
  "emeraldsparrow.nvim"
)

-- Require the installed package
-- and start using it.
require("emeraldsparrow").setup(
  {
    transparent = false
  }
)
```

To install a package, you must always load ***Nuwa*** itself and use
the returned instance of ***Nuwa***.

- Installing a package: Packages are installed by calling the `installPackage` function on a loaded instance of ***Nuwa***. This function expects three arguments: i) the Git hosting provider, ii) the owner of the Git repository containing the package, and iii) the name of the Git repository. This enables users of Neovim and ***Nuwa*** to install packages from any platform hosting Git repositories. To load a package saved locally on disk, call the `installLocal` function on a loaded Nuwa instance supplying the absolute path of the package as an argument.
- Updating a package: When Neovim is entered, all packages are updated automatically. This is only done for packages installed from a remote Git repository.
- Removing a package: To remove a package, ***Nuwa*** offers the `NuwaDelete` command. This command expects the name of a package as an argument. This command is only for packages installed from a remote Git repository.
- Updating ***Nuwa***: Nuwa itself is updated when the `setup` function is called on a loaded instance of ***Nuwa***.
- Paths:
    - Nuwa packages are saved in the `nuwaPkgs` directory inside Neovim's data directory. 
    - Nuwa itself is saved in the `nuwa` directory inside Neovim's data directory.

## CHANGELOG :black_nib:

### Version 0.1.0

- Initial release.
- Upload to GitHub.

## NOTE :scroll:

- *Nuwa.nvim :package: :swan:* by *Alyx Shang :black_heart:*.
- Licensed under the [FSL v1](https://github.com/alyxshang/fair-software-license).
