-- TODO: Something is seriously impacting help performance
--  This is impacting startup performancermagatti/auto-session

--Aliases
local opt = vim.opt
local cmd = vim.cmd
local api = vim.api
local fn  = vim.fn
local g = vim.g


function prequire(name)		-- Graceful fallback if packages aren't installed
	local status, lib = pcall(require, name)
	if(status) then return lib end
	-- Return a do nothing object
	return setmetatable({}, {__index = function() return function() end end})
end

-- Searching
opt.ignorecase = true					-- Case insensitive searching,
opt.smartcase = true					--   Unless I use capitals
-- Tab settings
opt.tabstop = 4							-- How wide tabs are
opt.shiftwidth = 0						-- How many spaces >> and << use
opt.softtabstop = 4
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
cmd[[colorscheme selenized_bw]]			-- jan-warchol/selenized
opt.background = "dark"					-- Color scheme
-- Mouse
opt.mouse = "nv"						-- Mouse support
opt.mousemodel = "popup_setpos"			-- TODO: customise popup menu
-- Misc
opt.wrap = false						-- Wrapping, is true in unnamed buffers, .txt, .md, .adoc
opt.syntax = "on"						-- Syntax highlighting
opt.spell = true						-- Spellcheck
display = { "lastline", "uhex", "msgsep" }
-- Folding
opt.foldmethod = "expr"					-- Use treesitter to determine folding
opt.foldexpr = "nvim_treesitter#foldexpr()"
-- Splitting
opt.splitright = true					-- New windows on the right
-- Show indents
opt.list = true
opt.listchars = { tab = '│ ', lead = '·', trail = '៖', nbsp = '␣', precedes = '←', extends= '→' }		-- TODO: Colours, use conceal so it hides the ៖ with when typing
api.nvim_set_hl(0, "Whitespace", { link = "Comment" })


-- fn.match( "Unicode", "[^\\x00-\\x7F]")					-- Highlight non ascii charactersℚ
--fn['syntax match']("Unicode",  "[^\\x00-\\x7F]")
cmd [[ syntax match Unicode '[^\x00-\x7E]' ]]
api.nvim_set_hl(0, "Unicode", { fg=g.palette_bright_red, bg=g.palette_background }) 


cmd [[ syntax match Trailing_Tabs '\S\zs\t\+' ]]
-- api.nvim_set_hl(0, "Traling_Tabs", {fg=g.terminal_color_0, blend=100})
api.nvim_set_hl(0, "Traling_Tabs", { fg=NONE, bg=NONE })
-- fn.match( "Trailing_Tabs", "\\S\\zs\\t\\+")				-- Only show tabs at the start of the line

cmd [[
nm <silent> <F1> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name")
    \ . '> trans<' . synIDattr(synID(line("."),col("."),0),"name")
    \ . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name")
    \ . ">"<CR>
]]


fn.match("as", "a")
api.nvim_set_hl(0, "as", {fg='red'})

-- TODO: Trailing tabs & spaces, except in comments, handle markdown seperately
--			seet :h syn-containedin
-- TODO: hide listchars on cursor line

-- Evilish mode
opt.virtualedit = "block,onemore"
opt.selection = "exclusive"
opt.guicursor = "n-v-c-sm:ver50,i-ci:ver25-Cursor-blinkwait200-blinkon150-blinkoff100,r-cr-o:hor80"

opt.scrolloff = 5						-- Keep cursor 5 rows from the edges
opt.sidescrolloff = 5					-- Keep cursor 5 columns from the edges

-- Netrw
-- g.netrw_keepdir = 1
-- g.netrw_banner = 0
-- g.netrw_liststyle = 3
-- g.netrw_localcopydircmd = 'cp -r'
g.netrw_list_hide = "\\(^\\|\\s\\s\\)\\zs\\.\\S\\+"		-- Hide dotfiles (gh to toggle)


----
--		Auto Commands
----

api.nvim_create_autocmd( 'TextYankPost',		-- Highlight yanked text
	{ callback = function() vim.highlight.on_yank({higroup="Visual"}) end })
api.nvim_create_autocmd( 'CursorHold', 			-- Clear command line automatically
	{ command = "echon ''" })
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
api.nvim_create_autocmd( 'BufEnter',			-- Wrap in text files
{ pattern = {"*.md", "*.adoc", "*.txt" }, callback = function() opt.wrap = true end })


----
--		Mappings
----
local function map(mode, lhs, rhs, opts)		-- convenience function
	local options = {noremap = true}
	if opts then options = vim.tbl_extend('force', options, opts) end
	vim.keymap.set(mode, lhs, rhs, options)
end

local function feedkeys(key, mode)				-- convenience function
	api.nvim_feedkeys(api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

map("n", "zO", "zCzO")
map("", "x", "d")
map("n", "xx", "dd")
map("v", "X", "D")
map("n", "s", "ch")
map("n", "<C-w><C-h>", "<C-w>100h")
map("n", "<C-w><C-j>", "<C-w>100j")
map("n", "<C-w><C-k>", "<C-w>100k")
map("n", "<C-w><C-l>", "<C-w>100l")
-- TODO: Map Shift-Enter to insert newline above in insert mode

-- Evilish mode
map("n", "a", "")
map("n", "A", "")
map("n", "<C-i>", "A")
map("", "$", "g$")		-- TODO: wrapped lines
-- map("", "p", function()
	-- if fn.col(".") == 1 then
		-- feedkeys("n", "p")
	-- else
		-- feedkeys("n", "hpl")
	-- end
-- end)

-- Unified Scrolling
map("", "<C-k>", "<C-b>zz")
map("", "<C-j>", function()		-- Don't scroll past the end of the buffer
	if fn.line("$") >= fn.line("w$") + (fn.line("w$") - fn.line("w0")) then
		feedkeys("<C-f>zz", "n")
	else
		feedkeys("Gz-", "n")
	end
end)
map("", "<C-u>", "")
map("", "<C-u>", "")
map("", "<C-f>", "")
map("", "<C-f>", "")
map("", "<C-e>", "")
map("", "<C-y>", "")
map("i", "<Esc>", "<Esc>l")

map('n', "gd", vim.lsp.buf.definition)
map('n', "gD", vim.lsp.buf.declaration)

map('n', '<C-/>', function() print('lower') end)
map('n', '<C-S-/>', function() print('Upper') end)

-- TODO: fix cw,dw etc

local comment_map = {
	toggler = {			-- TODO: Reevaluate mappings
		line = '<A-c><Enter>',		-- Maybe ctrl-space?
		block = '<A-S-c><Enter>'
	},
	opleader = {
		line = '<A-c>',
		block = '<A-S-c>',
	},
	extra = {
		above = '<A-c>O',
		below = '<A-c>o',
		eol = '<A-c><C-i>',
	},
}

-- Plugins

local function contains(list, condition)
	for _, value in pairs(list) do
		if condition(value) then return true end
	end
	return false
end

local function toggle_window(condition, open_cmd, close_cmd)
	if not(contains(fn.getwininfo(), condition)) then
		cmd(open_cmd)
	else
		cmd(close_cmd)
	end
end


-- simrat39/symbols-outline.nvim
map("n", "<A-b>", "<Cmd>SymbolsOutline<Enter>")
-- Netrw
map("n", "<A-e>", "<Cmd>Ex<Enter>")
-- DanilaMihailov/beacon.nvim
map("n", "<A-m>", "<Cmd>Beacon<Enter>")
-- Quickfix
map("n", "<A-q>", function() toggle_window(
	function(item) return fn.win_gettype(item.winid) == "quickfix" end,
	"copen", "cclose") end)




----
--		Scripts
----

----
--		Languages
----


-- Rust


local rt = prequire("rust-tools")
rt.setup({
	server = {
		on_attach = function(_, bufnr)
			-- Hover actions
			vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
			-- Code action groups
			vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
		end,
	},
})




----
--		Plugin options
----

-- p00f/nvim-ts-rainbow
prequire('nvim-treesitter.configs').setup({
	rainbow = {				-- TODO: Not working
		enable = true,
		colors = {
			g.pallete_bright_red,
			g.pallete_bright_blue,
			g.pallete_bright_orange,
			g.pallete_bright_violet,
			g.pallete_bright_orange,
			g.pallete_bright_yellow,
			-- g.pallete_bright_green,
			-- g.pallete_bright_cyan,
		}
	}
})


-- LunarWatcher/auto-pairs
g.AutoPairsUseInsertedCount = 1
g.AutoPairsShortcutToggle = ""
g.AutoPairsShortcutFastWrap = ""
g.AutoPairsShortcutJump = ""
g.AutoPairsMapBS = 1


-- norcalli/nvim-colorizer.lua
prequire ("colorizer").setup({
	"*"
},{ 
	names = false,
	RRGGBBAA = true
})

-- simrat39/symbols-outline.nvim
prequire("symbols-outline").setup({
	position = "left",
	auto_close = true,
})

-- lukas-reineke/indent-blankline.nvim
g.indent_blankline_use_treesitter = true
g.indent_blankline_max_indent_increase = 1
g.indent_blankline_show_first_indent_level = false


-- williamboman/mason.nvim
prequire("mason").setup()

-- williamboman/mason-lspconfig.nvim
prequire("mason-lspconfig").setup({
	automatic_installation = true,
})


-- numToStr/Comment.nvim
prequire("Comment").setup(comment_map)

-- xiyaowong/nvim-cursorword
g.cursorword_disable_at_startup = false
api.nvim_set_hl(0, "CursorWord", { link = "Visual" })		-- Need to make a different color

-- ggandor/leap.nvim
prequire('leap').add_default_mappings()

-- andymass/vim-matchup
g.matchup_matchparen_offscreen = { method = "popup" }

-- nvim-treesitter/nvim-treesitter-context
prequire('treesitter-context').setup()

-- lukas-reineke/virt-column.nvim
prequire("virt-column").setup({char = '│'})

-- rmagatti/auto-session
prequire("auto-session").setup {
	log_level = "error",
	auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/"},
}

-- svermeulen/vim-yoink
g.yoinkSyncNumberedRegisters = 1
g.yoinkIncludeDeleteOperations = 1
g.yoinkSavePersistently = 1
g.yoinkAutoFormatPaste = 1
g.yoinkMoveCursorToEndOfPaste = 1
g.yoinkSwapClampAtEnds = 0
g.yoinkIncludeNamedRegisters = 0

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

	use "neovim/nvim-lspconfig"							-- Default settings for language servers
	use "williamboman/mason.nvim"						-- Manage external tooling
	use "williamboman/mason-lspconfig.nvim"				-- Link Mason to LSP-config
	use "nvim-treesitter/nvim-treesitter"				-- Treesitter interface
	use "mfussenegger/nvim-dap"							-- Debug Adapter Protocol client

	use "nvim-lua/plenary.nvim"							-- Utils
	use "simrat39/rust-tools.nvim"						-- Rust tools
	use {"nvim-telescope/telescope.nvim",				-- fuzzy finder
		branch = "0.1.x"}
	use {'romgrk/fzy-lua-native', run = 'make'}
	use "simrat39/symbols-outline.nvim"					-- Structure view		TODO: Setup keybindings
	use "romainl/vim-cool"								-- Disable search highlighting automatically	TODO: Check back, this may be native
	use "p00f/nvim-ts-rainbow"							-- Rainbow brackets
	use "norcalli/nvim-colorizer.lua"					-- Highlight colours
	use "LunarWatcher/auto-pairs"						-- Make inserting brackets nicer
	use "DanilaMihailov/beacon.nvim"					-- Highlight cursor pos				-- TODO: sometimes doesn't auto highlight
	use "numToStr/Comment.nvim"							-- Comment toggle
	use "andymass/vim-matchup"							-- Allow words to delimit blocks, e.g. if, fi
	use "xiyaowong/nvim-cursorword"						-- Highlight matching words
	-- use "ggandor/leap.nvim"								-- Quick local navigation		-- TODO: Not working
	-- use "nvim-treesitter/nvim-treesitter-context"		-- Show branch context			-- TODO: Not working
	use "lukas-reineke/virt-column.nvim"				-- Show character in virtual column
	use "tpope/vim-vinegar"								-- Netrw improvements
	use "tpope/vim-speeddating"							-- Increment dates
	use "tpope/vim-characterize"						-- More info with ga
	use "tpope/vim-abolish"								-- Expand functionality of :s and abbreviations, coerce text	-- TODO: Subvert should have incremental highlighting -- TODO: remap change to s
	use "kylechui/nvim-surround"						-- Surround with brackets
	use "rmagatti/auto-session"							-- Automatic session management
	-- use "svermeulen/vim-cutlass"						-- Make delete actually delete
	-- use "svermeulen/vim-yoink"							-- Copy history
	use "wellle/targets.vim"							-- Select brackets easily -- TODO: It would be great to have a treesitter based solution, so it works with fn end etc and comments

	-- keep at the end
	if packer_bootstrap then		-- If packer was just installed run sync so it installs all the other plugins
		require("packer").sync()
	end
end)
