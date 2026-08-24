-- TODO
-- Prose mode
--	- Thesaurus
--	- Dictionary Lookup
--	- Hide line numbers
--	- Soft wrap at 80 characters
-- When moving from a split, to a side with 2 splits, go back to the most recently visited one
-- Replace Packer
local opt = vim.opt
local api = vim.api
local cmd = vim.cmd
local fn = vim.fn
local g = vim.g


function prequire(name)                -- Graceful fallback if packages aren't installed
	local status, lib = pcall(require, name)
	if(status) then return lib end
	-- Return a do nothing object
	print("Package " .. name .. " couldn't be loaded")
	return setmetatable({}, {__index = function() return function() end end})
end

-- Searching
opt.ignorecase = true					-- Case insensitive searching,
opt.smartcase = true					--   Unless I use capitals
-- Tab settings
opt.tabstop = 4							-- How wide tabs are
opt.shiftwidth = 4						-- How many spaces >> and <<
-- Indentation
opt.autoindent = true					-- When inserting a newline match indentation
opt.smartindent = true					-- Insert indents automatically
-- Number column
opt.number = true						-- Show line numbers
opt.signcolumn = "number"				-- Replace numbers with error markers
-- Completion
opt.wildmode = { "longest", "list:full" }		-- Command line completion
opt.completeopt = "menuone,longest"		-- Insert mode completion
-- Colors
opt.termguicolors = true				-- Truecolor support
-- cmd[[colorscheme selenized_bw]]			-- jan-warchol/selenized
-- opt.background = "dark"					-- Color scheme
-- Mouse
opt.mouse = "nv"						-- Mouse support
opt.mousemodel = "popup_setpos"			-- TODO: customise popup menu
-- Spelling
opt.spell = true						-- Spellcheck
-- opt.spelllang = "en_nz"					-- Spell things correctly
opt.spelloptions = "camel"				-- Split camelCase words for spellchecking
opt.spellsuggest:append("10")			-- 10 suggestions max
-- Folding
opt.foldmethod = "indent"				-- Fold on equal indentation
-- Misc
opt.shm:append("I")						-- Disable :intro message
opt.fillchars:append("eob: ")			-- Hide ~ at end of buffer
opt.wrap = false						-- Text wrapping, is true in unnamed buffers, .txt, .md, .adoc
opt.display = { "lastline", "uhex" }	-- Truncate and show hex codes for unprintable characters
opt.cpoptions:remove('_')				-- Fix cw inconsistency
opt.cpoptions:append('M')				-- Ignore escaped brackets for matchpairs
opt.splitright = true					-- New windows on the right
opt.clipboard:append("unnamedplus")		-- Use system clipboard
-- Show indents
opt.list = true
opt.listchars = { tab = '  ', leadtab = '│ ', lead = '·', trail = '៖', nbsp = '␣', precedes = '←', extends= '→' }		-- TODO: use conceal or autocmd so it hides the ៖ with when typing
-- Syntax highlighting
-- cmd([[syn match AcronymNoSpell "\<\(\u\|\d\)\{3,}s\?\>" contains=@NoSpell]])	-- Don't spellcheck acronyms, TODO: Doesn't work
-- cmd([[syn match UrlNoSpell "\w\+:\/\/\S\+" contains=@NoSpell]])					-- Or URLs		TODO: Doesn't work in text files
vim.api.nvim_set_hl(0, "SpellCap", {sp="Blue", undercurl=true})		-- TODO: Doesn't work

-- Evilish mode
opt.virtualedit = "block,onemore"
opt.selection = "exclusive"
opt.guicursor = "n-v-c-sm:ver20,i-ci:ver10-Cursor-blinkwait200-blinkon250-blinkoff200,r-cr-o:hor20"	-- TODO: In gnome-terminal you can't set the width of the cursor
opt.scrolloff = 5						-- Keep cursor 5 rows from the edges
opt.sidescroll = 1						-- Scroll one column at a time
opt.sidescrolloff = 5					-- Keep cursor 5 columns from the edges

-- Netrw
g.netrw_list_hide = "\\(^\\|\\s\\s\\)\\zs\\.\\S\\+"		-- Hide dotfiles (gh to toggle)
g.netrw_browsex_viewer	= "xdg-open"	-- TODO: If it fails it should show up in a hit enter window, not a buffer


----
--		Auto Commands
----
api.nvim_create_autocmd( 'TextYankPost',		-- Highlight yanked text
	{ callback = function() vim.highlight.on_yank({higroup="Visual"}) end })
api.nvim_create_autocmd( 'CmdlineLeave', 			-- Clear command line automatically
	{ callback = function()	-- NOTE: Unfortunately no way to clear error messages currenntly
		local cmdline_char = fn.expand("<afile>")	-- Store it because it's empty when deferred
		vim.defer_fn(function()	
			if cmdline_char == ':' then
				print " "
			end
		end, 2000)
	end })
api.nvim_create_autocmd( 'BufWinEnter',			-- Restore cursor position when I open a file
	{ pattern = "?*", command = "silent! loadview"})
api.nvim_create_autocmd( {"BufWinLeave", "BufLeave", "BufWritePost", "BufHidden", "QuitPre"},
	{ pattern = "?*", nested = true, command = "silent! mkview"})
api.nvim_create_autocmd( 'BufEnter',			-- Only show column at 80 lines in editable buffers
	{ callback = function()
		if api.nvim_buf_get_option(0, "modifiable") then
			opt.colorcolumn = "80"
		else
			opt.colorcolumn = ""
		end
	end })

local function setupWriting()
	opt.wrap = true
	opt.list = false
	opt.linebreak = true
	opt.colorcolumn = ""
	opt.foldenable = false
	-- Also disable xiyaowong/nvim-cursorword
end
api.nvim_create_autocmd( 'BufEnter',			-- Wrap in text files
{ pattern = {"*.md", "*.adoc", "*.txt", "{}"}, callback = setupWriting})

----
--		Mappings
----

-- convenience functions
local function map(mode, lhs, rhs, opts)
	local options = {remap = false}
	if opts then options = vim.tbl_extend('force', options, opts) end
	vim.keymap.set(mode, lhs, rhs, options)
end

local function feedkeys(keys, mode)
	if not mode then mode = "n" end
	api.nvim_feedkeys(api.nvim_replace_termcodes(keys, true, true, true), mode, false)
end

-- Misc
map("n", "zO", "zCzO")
map("", "j", "gj", {remap = true})
map("", "k", "gk", {remap = true})
map("n", "q:", "")	-- Disable command line window (:<C-f> still works)
map("n", "q/", "")
map("n", "q?", "")
-- Actually delete
map("", "x", "d")
map("n", "xx", "dd")
map("v", "X", "D")
map("n", "s", "ch")
-- Split manipulation
map("n", "<C-w><C-h>", "<C-w>100h")		-- Hold ctrl to jump to the end
map("n", "<C-w><C-j>", "<C-w>100j")
map("n", "<C-w><C-k>", "<C-w>100k")
map("n", "<C-w><C-l>", "<C-w>100l")
map("i", "<A-h>", "<Esc><C-w>ha")
map("i", "<A-j>", "<Esc><C-w>ja")
map("i", "<A-k>", "<Esc><C-w>ka")
map("i", "<A-l>", "<Esc><C-w>la")
map("n", "<A-h>", "<Esc><C-w>h")
map("n", "<A-j>", "<Esc><C-w>j")
map("n", "<A-k>", "<Esc><C-w>k")
map("n", "<A-l>", "<Esc><C-w>l")
map("n", "<C-w>n", ":vnew<Enter>")
-- Comments
map("v", "<C-_>", "gc")	-- TODO: ctrl+/ doesn't work for terminal reasons, find a different mapping
map("n", "<C-_>", "gcc")

-- Evilish mode
map("i", "<Esc>", function()
	if vim.api.nvim_win_get_cursor(0)[2] == 0 then
		feedkeys("<Esc>")
	else
		feedkeys("<Esc>l")
	end

end)
map("n", "a", "")
map("n", "A", "")
map("n", "<C-i>", "A")
map("n", "<C-s-o>", "<C-i>")	-- TODO: This isn't working
map({"n", "v"}, "$", "$l")
map({"n", "v"}, "p", function()
	if vim.fn.getregtype(vim.v.register):match("V") then
		feedkeys("p")
	else
		feedkeys("P")
	end
end)
map({"n", "v"}, "P", "gP")
map("n", "t", "")
map("n", "T", "")
map("n", "e", function()
	col = vim.api.nvim_win_get_cursor(0)[2]
	line = vim.api.nvim_get_current_line()
	if  line:sub(col+1,col+1):match("%S") and line:sub(col+2,col+2):match("%s") then
		feedkeys("l")
	else
		feedkeys("el")
	end
end)
map("n", "E", function()
	col = vim.api.nvim_win_get_cursor(0)[2]
	line = vim.api.nvim_get_current_line()
	if  line:sub(col+1,col+1):match("%S") and line:sub(col+2,col+2):match("%s") then
		feedkeys("l")
	else
		feedkeys("El")
	end
end)

-- Unified Scrolling
map("", "<C-k>", "10gk", {remap = true})
map("", "<C-j>", "10gj", {remap = true})
map("", "<C-u>", "")
map("", "<C-f>", "")
map("", "<C-e>", "")
map("", "<C-y>", "")

-- VSCodium
if vim.g.vscode then
	local vscode = require('vscode')
	-- Remap folding keys
	vim.keymap.set('n', 'zM', function() vscode.call("editor.foldAll") end, { noremap = true, silent = true })
	vim.keymap.set('n', 'zR', function() vscode.call("editor.unfoldAll") end, { noremap = true, silent = true })
	vim.keymap.set('n', 'zc', function() vscode.call("editor.fold") end, { noremap = true, silent = true })
	vim.keymap.set('n', 'zC', function() vscode.call("editor.foldRecursively") end, { noremap = true, silent = true })
	vim.keymap.set('n', 'zo', function() vscode.call("editor.unfold") end, { noremap = true, silent = true })
	vim.keymap.set('n', 'zO', function() vscode.call("editor.unfoldRecursively") end, { noremap = true, silent = true })
	vim.keymap.set('n', 'za', function() vscode.call("editor.toggleFold") end, { noremap = true, silent = true })
end

-- Mouse
-- map("n", "<LeftMouse>", "<LeftMouse>i", {remap=false})	-- TODO: Left click to insert there, currently prevents drag to select which is the problem


-- simrat39/symbols-outline.nvim
map("n", "<A-b>", "<Cmd>SymbolsOutline<Enter>")
-- DanilaMihailov/beacon.nvim
map("n", "<A-m>", "<Cmd>Beacon<Enter>")


----
--		Scripts
----
prequire("timer")	-- Basic timer, call with :Timer [time in minutes]
require("debate")	-- Settings for adjing

----
--		Plugin options
----

-- windwp/nvim-autopairs
prequire("nvim-autopairs").setup({
	fast_wrap = {},
})


-- lukas-reineke/virt-column.nvim
prequire("virt-column").setup({
	char = '│',
	highlight = "Whitespace"
})

-- rmagatti/auto-session
prequire("auto-session").setup {
	log_level = "error",
	auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/"},
}

-- DanilaMihailov/beacon.nvim
g.beacon_minimal_jump = 5


----
--		VSCode
----
if g.vscode then
	opt.spell = false
end

----
--		Plugins
----
local ensure_packer = function()		-- Bootstrap Packer
	local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
		vim.cmd [[packadd packer.nvim]] return true
	end
	return false
end
local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)		-- Install packages
	use "wbthomason/packer.nvim"						-- Let Packer manage itself
	use "romainl/vim-cool"								-- Disable search highlighting automatically	NOTE: Check back, this may be native
	use "windwp/nvim-autopairs"							-- Make inserting brackets nicer
	use "DanilaMihailov/beacon.nvim"					-- Highlight cursor pos				-- TODO: sometimes doesn't auto highlight. TODO: Maybe just highlight line number on cursor line
	use "lukas-reineke/virt-column.nvim"				-- Show character in virtual column
	use "tpope/vim-vinegar"								-- Netrw improvements
	use "tpope/vim-characterize"						-- More info with ga
	use "tpope/vim-commentary"							-- gcc to comment line
	use "rmagatti/auto-session"							-- Automatic session management
	use "svermeulen/vim-cutlass"						-- Make delete actually delete

	-- keep at the end
	if packer_bootstrap then		-- If packer was just installed run sync so it installs all the other plugins
		require("packer").sync()
	end
end)
