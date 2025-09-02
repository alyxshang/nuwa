-- Nuwa.nvim by Alyx Shang.
-- Licensed under the FSL v1.

-- Declaring the module.
local M = {}

-- A function to emulate
-- a no-op function.
function pass()
end

M.delCommand = function()
  vim.api.nvim_create_user_command(
    'NuwaDelete',
    function(opts)
      local pkgPath = vim.fn.stdpath("data") .. "/nuwaPkgs/" .. opts.args
      local stat = vim.loop.fs_stat(pkgPath)
      if stat and stat.type == "directory" then
        vim.fn.delete(pkgPath, "rf")
        local pdStat = vim.loop.fs_stat(pkgPath)
        if pdStat and pdStat.type == "directory" then
          vim.schedule(
            function()
              vim.api.nvim_echo(
                {{"The package " .. pkgPath .. " could not be removed!", "Normal"}}, 
                true, 
                {}
              )
            end
          )
        else
          vim.schedule(
            function()
              vim.api.nvim_echo(
                {{"The package " .. pkgPath .. " was removed successfully!", "Normal"}}, 
                true, 
                {}
              )
            end
          )
        end
      else
        vim.schedule(
          function()
            vim.api.nvim_echo(
              {{"The package " .. pkgPath .. " is not installed!", "Normal"}}, 
              true, 
              {}
            )
          end
        )
      end
    end,
    {
      nargs = 1 
    }
  )
end

M.selfUpdateCommand = function()
  vim.api.nvim_create_user_command(
    'NuwaSelfUpdate',
    function(opts)
      local pkgPath = vim.fn.stdpath("data") .. "/nuwa"
      M.updatePackage(pkgPath)
    end,
    {
      nargs = 0
    }
  )
end


-- A function to create the "nuwaPkgs" directory
-- if it doesn't exist already.
M.setup = function(options)
  local nuwaPkgRoot = vim.fn.stdpath("data") .. "/nuwaPkgs"
  local check = vim.loop.fs_stat(nuwaPkgRoot)
  if check and check.directory then
    pass()
  else
    vim.fn.mkdir(nuwaPkgRoot, "p")
  end
  M.delCommand()
  M.selfUpdateCommand()
end

-- A function to update a package
-- by pulling the latest changes
-- from the cloned Git repository.
M.updatePackage = function(pkgPath)
  vim.loop.spawn(
    "git", 
      {
        args = {
          "-C",
          pkgPath,
          "pull"
        }
      },
      function(code, signal)
        if code == 0 then
          vim.schedule(
            function()
              vim.api.nvim_echo(
                {{"Updated repository " .. pkgPath .. "!", "Normal"}}, 
                true, 
                {}
              )
            end
          )
        else
          vim.schedule(
            function()
              vim.api.nvim_echo(
                {{"Failed to update repository " .. pkgPath .. "!", "Normal"}}, 
                true, 
                {}
              )
            end
          )
        end
      end
    )
end

-- A function to clone a Git repository
-- into the supplied target directory.
M.clonePackage = function(gitUrl, pkgPath)
  vim.loop.spawn(
    "git", 
      {
        args = {
	  "clone", 
	  "--depth=1", 
	  gitUrl, 
	  pkgPath
	}
      }, 
      function(code, signal)
        if code == 0 then
          vim.schedule(
            function()
              vim.api.nvim_echo(
                {{"Cloned " .. gitUrl .. " into " .. pkgPath .. "!", "Normal"}}, 
                true, 
                {}
              )
	    end
          )
        else
          vim.schedule(
            function()
              vim.api.nvim_echo(
                {{"Failed to clone " .. gitUrl .. "!", "Normal"}}, 
                true, 
                {}
              )
	    end
          )
        end
      end
    )
end

-- A function to install a package given the 
-- package's Git host, owner, and project name.
M.installPackage = function(gitHost, owner, project)
  local pkgPath = vim.fn.stdpath("data") .. "/nuwaPkgs/" .. project
  local gitUrl = gitHost .. "/" .. owner .. "/" .. project .. ".git"
  local check = vim.loop.fs_stat(pkgPath)
  vim.opt.rtp:prepend(pkgPath)
  if check and check.type == "directory" then
    M.updatePackage(pkgPath)
  else
    M.clonePackage(gitUrl, pkgPath)
  end
end

-- Exporting the 
-- created module.
return M
