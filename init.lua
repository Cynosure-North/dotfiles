local opt = vim.opt			-- alias

vim.cmd [[colorscheme moonfly]]	-- Set colour scheme

opt.ignorecase = true       -- Case insensitive searching
opt.smartcase = true        -- Unless I use capitals
opt.tabstop = 4             -- How many spaces equal tab inserts
opt.shiftwidth = 0          -- How many spaces >> & << use. 0 means it's equal to tabstop
opt.softtabstop = -1        -- How many spaces tabs count for when editing. -1 means it's equal to shiftwidth
opt.autoindent = true       -- When inserting a newline match indentation
opt.smartindent = true      -- Insert indents automatically
opt.number = true           -- Show line numbers
opt.syntax = "on"           -- Syntax highlighting opt.mouse = "a"             -- Mouse support
opt.spell = true            -- Spellcheck
opt.termguicolors = true    -- Truecolor support

----
--		Plugin options
----

-- luochen1990/rainbow
vim.g.rainbow_active = 1	-- Enable rainbow brackets

-- eapache/auto-pairs
vim.g.AutoPairsFlyMode = 1	-- When you type a closing bracket jump to it, even if it's over characters
vim.g.AutoPairsOnlyWhitespace = 1 -- Only insert pair if there's whitespace	-- TODO: Submit pr to add option to only insert if it's whitespace or the corresponding closing bracket

----
--		Plugins
----
local ensure_packer = function()		-- Bootstrap packer
  local fn = vim.fn	-- alias
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]] return true
  end
  return false
end

return require('packer').startup(function(use)		-- Install packages
	use 'wbthomason/packer.nvim'						-- Let Packer manage itself
	use 'bluz71/vim-moonfly-colors'						-- Colour scheme
	use {'nvim-telescope/telescope.nvim',				-- fuzzy finder
		branch = '0.1.x',
		requires = {{'nvim-lua/plenary.nvim'}} }	-- utils
	use 'luochen1990/rainbow'							-- Rainbow brackets, fork of jiangmiao/auto-pairs
	use 'eapache/auto-pairs'							-- Make inserting brackets nicer

	-- keep at the end
	if ensure_packer() then		-- If packer was just installed run sync so it installs all the other plugins
		require('packer').sync()
	end
end)
