-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  -- Get lazy.nvim commit from lazy-lock.json (if present)
  local lazycommit = "HEAD"
  local lazylockpath = vim.fn.stdpath("config") .. "/lazy-lock.json"
  if (vim.uv or vim.loop).fs_stat(lazylockpath) then
    local file = io.open(lazylockpath, "r")
    if file then
      local content = file:read("*all")
      file:close()
      local data = vim.json.decode(content)
      if data and data["lazy.nvim"] and data["lazy.nvim"].commit then
        lazycommit = data["lazy.nvim"].commit
      end
    end
  end
  -- Clone lazy.nvim
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
  -- Checkout to SHA (from above - if required)
  out = vim.fn.system({ "git", "-C", lazypath, "checkout", lazycommit })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to checkout lazy.nvim commit " .. lazycommit .. ":\n", "ErrorMsg" },
      { out, "WarningMsg" },
    }, true, {})
    vim.ui.input({ prompt = "Do you want to continue (y/n)[n]:" }, function(s)
      if vim.fn.tolower(s) ~= "y" then
        os.execute("rm -rf " .. lazypath)
        os.exit(1)
      end
    end)
  end
end
vim.opt.rtp:prepend(lazypath)
