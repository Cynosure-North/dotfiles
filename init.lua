--Aliases
local opt = vim.opt
local cmd = vim.cmd
local api = vim.api
local fn  = vim.fn


function prequire(name)		-- Graceful fallback if packages aren't installed
	local status, lib = pcall(require, name)
	if(status) then return lib end
	-- Return a do nothing object
	return setmetatable({}, {__index = function() return function() end end})
end

-- Searching
opt.ignorecase = true       			-- Case insensitive searching,
opt.smartcase = true        			--   Unless I use capitals
-- Tab settings
opt.tabstop = 4             			-- How wide tabs are
opt.shiftwidth = 0          			-- How many spaces >> and << use
opt.softtabstop = 4
-- Indentation
opt.autoindent = true       			-- When inserting a newline match indentation
opt.smartindent = true      			-- Insert indents automatically
-- Number column
opt.number = true           			-- Show line numbers
opt.signcolumn = "number"				-- Replace numbers with error markers
-- Completion
opt.wildmode = "longest:list,full"		-- Command line completion
opt.completeopt = "menuone,longest"		-- Insert mode completion
-- Colors
opt.termguicolors = true				-- Truecolor support
cmd[[colorscheme selenized_bw]]			-- jan-warchol/selenized
opt.background = "dark"					-- Color scheme
-- Mouse
opt.mouse = "nv"						-- Mouse support
opt.mousemodel = "popup_setpos"
-- Misc
opt.syntax = "on"           			-- Syntax highlighting
opt.spell = true            			-- Spellcheck
-- Folding
opt.foldmethod = "expr"					-- Use treesitter to determine folding
opt.foldexpr = "nvim_treesitter#foldexpr()"
-- TODO have it store and remember manual folds ( maybe also save cursor position )
-- Show indents
opt.list = true
opt.listchars = "tab:│ ,lead:·,trail:៖,nbsp:␣,precedes:←,extends:→"		-- TODO: Colours, use conceal so it hides the ៖ with when typing
api.nvim_set_hl(0, "Whitespace", { link = "Comment" })
--fn.match( group-name = "Unicode", pattern = "[^\x00-\x7F]", options = {display = true, oneline = true}, keepend = true )					-- Highlight non ascii characters
api.nvim_set_hl(0, "Unicode", { link = "Error" })
-- TODO: Trailing tabs & spaces, except in comments, handle markdown seperately
-- TODO: hide listchars on cursor line
-- TODO: investigate https://github.com/tpope/vim-sensible/blob/master/plugin/sensible.vim

-- Evilish mode
opt.virtualedit = "block,onemore"
opt.selection = "exclusive"
opt.guicursor = "n-v-c-sm:ver50,i-ci:ver25-Cursor-blinkwait200-blinkon150-blinkoff100,r-cr-o:hor80"

opt.wrap = false
opt.scrolloff = 5						-- Keep cursor 5 rows from the edges
opt.sidescrolloff = 5					-- Keep cursor 5 columns from the edges

-- Netrw
vim.g.netrw_keepdir = 0
vim.g.netrw_winsize = 25
vim.g.netrw_preview = 1
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4
-- vim.g.netrw_altv = 1
vim.g.netrw_localcopydircmd = 'cp -r'


----
--		Auto Commands
----

api.nvim_create_autocmd( 'TextYankPost',		-- Highlight yanked text
	{ callback = function() vim.highlight.on_yank() end })
api.nvim_create_autocmd( 'CursorHold', 			-- Clear command line automatically
	{ command = "echon ''" })
api.nvim_create_autocmd( 'BufWinEnter',			-- Restore cursor position when I open a file
	{ callback = function() api.nvim_win_set_cursor(0, api.nvim_buf_get_mark(0, '"')) end })


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

-- Evilish mode
map("n", "a", "")
map("n", "A", "")
map("n", "<C-i>", "A")
map("", "$", "g$")		-- TODO: wrapped lines
map("n", "p", "P")		-- TODO: pastes lines on the line above
map("n", "x", "X")
map("n", "X", "x")
map("n", "s", "ch") 

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


-- Plugins

-- simrat39/symbols-outline.nvim
map("n", "<A-b>", "<Cmd>SymbolsOutline<Enter>")	-- "OUTLINE"
-- Netrw
map("n", "<A-e>", "<Cmd>Vex<Enter>")				-- "NetrwTreeListing"
-- DanilaMihailov/beacon.nvim
map("n", "<A-c>", "<Cmd>Beacon<Enter>")

----
--		Scripts
----

--prequire("custom_map")

----
--		Languages
----


-- Rust

prequire("rust-tools").setup({
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

-- luochen1990/rainbow
vim.g.rainbow_active = 1	-- Enable rainbow brackets

-- eapache/auto-pairs
vim.g.AutoPairsFlyMode = 1	-- When you type a closing bracket jump to it, even if it's over characters
vim.g.AutoPairsOnlyWhitespace = 1 -- Only insert pair if there's whitespace
vim.g.AutoPairsUseInsertedCount = 1 -- Only jump to matching brackets that have been inserted this time

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
vim.g.indent_blankline_use_treesitter = true
vim.g.indent_blankline_max_indent_increase = 1
vim.g.indent_blankline_show_first_indent_level = false

-- numToStr/Comment.nvim
prequire('nvim_comment').setup(comment_map)


-- hrsh7th/nvim-cmp

local cmp = prequire('cmp')
cmp.setup({
	snippet = {
		expand = function(args)
			fn["vsnip#anonymous"](args.body)
		end,
	},
	view = {
		entries = { name = "custom", selection_order = "near_cursor" }
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "nvim-lsp-signature-help" },
		{ name = "nvim_lua" },
		{ name = "vsnip" },
		{ name = "path" },
		{ name = "fuzzy_buffer" },
		--{ name = "spell" },		-- TODO
		--{ name = "dictionary", keyword_length = 2, },
	})
})

cmp.setup.cmdline({ '/', '?' }, {		-- Use buffer sources for '/', '?'
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "fuzzy_buffer" },
	}
})

cmp.setup.cmdline(':', { -- Use cmdline & path source for ':
	mapping = cmp.mapping.preset.cmdline(),		-- Don't show hidden files until I prefix .
	sources = cmp.config.sources({
		{ name = "fuzzy_path", option = { fd_cmd = {'fdfind', '-d', '1', '-p', '-t', 'd', '-t', 'f'} } },		-- TODO
		-- { name = "cmdline" },		-- TODO
	})
})



local capabilities = prequire('cmp_nvim_lsp').default_capabilities()		-- Specify capabilities for lsp completion
prequire('lspconfig')['rust_analyzer'].setup {
	  capabilities = capabilities
}

-- williamboman/mason.nvim
prequire("mason").setup()

-- williamboman/mason-lspconfig.nvim
prequire("mason-lspconfig").setup({
	automatic_installation = true,
})

prequire("nvim-treesitter").setup({
  ensure_installed = { "rust", "lua", "vim", "help" },
  auto_install = false,
})



function smart_toggle()
	local vmode = fn.mode('.+')
	local cfg = prequire("Comment.config"):get()
	local utils = prequire("Comment.utils")
	local Op = prequire("Comment.opfunc")
	
	local range
	if string.match(vmode, '[^vV]') then
		range = { srow = fn.line("."), scol = 0, erow = fn.line("."), ecol = 0 }
	else
		-- Get the bounds of the visual selection
		-- The _ discard the buffer number returned, because we only care about the current buffer
		-- getpos('v') returns the start of the visual selection
		-- getpos('.') returns the cursor position
		local _, srow, scol, soff, _, erow, ecol, eoff = fn.getpos('v'), fn.getpos('.') 
		range = { srow = srow, scol = scol, erow = erow, ecol = ecol }		-- TODO: Might need to handle offset
	end
    local same_line = range.srow == range.erow

    local ctx = {
        cmode = utils.cmode.toggle,
        range = range,
        cmotion = utils.cmotion[vmode] or utils.cmotion.line,
        ctype = same_line and utils.ctype.linewise or utils.ctype.blockwise,
    }
	print(vim.inspect(ctx))

    local lcs, rcs = utils.parse_cstr(cfg, ctx)

    local params = {
        range = range,
        lines = utils.get_lines(range),
        cfg = cfg,
        cmode = ctx.cmode,
        lcs = lcs,
        rcs = rcs,
    }

    if string.match(vmode, '[v]') then		-- TODO: Visual line uncommenting doesn't work
        Op.blockwise(params)				-- visual char doesn't work at all
    else									-- TODO: visual-block
        Op.linewise(params)
    end
end

function __toggle_contextual(vmode)					-- TODO: In normal mode just comment the line
    local cfg = require('Comment.config'):get()		-- In visual line comment linewise
	local U = require('Comment.utils')				-- In visual char comment blockwise even if it's on the one line
	local Op = require('Comment.opfunc')			--		or at the very least, at the start of the selection

    local start, _end = api.nvim_buf_get_mark(0, '['), api.nvim_buf_get_mark(0, ']')
    local range = { srow = start[1], scol = start[2], erow = _end[1], ecol = _end[2] }
    local same_line = range.srow == range.erow

    local ctx = {
        cmode = U.cmode.toggle,
        range = range,
        cmotion = U.cmotion[vmode] or U.cmotion.line,
        ctype = same_line and U.ctype.linewise or U.ctype.blockwise,
    }

    local lcs, rcs = U.parse_cstr(cfg, ctx)
    local lines = U.get_lines(range)


    local params = {
        range = range,
        lines = lines,
        cfg = cfg,
        cmode = ctx.cmode,
        lcs = lcs,
        rcs = rcs,
    }

    if same_line then
        Op.linewise(params)
    else
        Op.blockwise(params)
    end
end

map('', '<A-w>', smart_toggle)
map('n', '<Leader>c', '<cmd>set operatorfunc=v:lua.__toggle_contextual<CR>g@')
map('x', '<Leader>c', '<cmd>set operatorfunc=v:lua.__toggle_contextual<CR>g@')

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
	use "hrsh7th/nvim-cmp"								-- Autocompletion Framework
	use "tzachar/fuzzy.nvim"							-- Fuzzy finding utils
	use "nvim-treesitter/nvim-treesitter"				-- Treesitter interface
	use({
		"hrsh7th/cmp-nvim-lsp",					-- LSP
		"hrsh7th/cmp-nvim-lsp-signature-help",	-- Function signatures
		"hrsh7th/cmp-nvim-lua",					-- Neovim Lua API
		"hrsh7th/cmp-vsnip",					-- Snippets
		"hrsh7th/cmp-cmdline",					-- Command line completion
		"f3fora/cmp-spell",						-- Spelling corrections
		"uga-rosa/cmp-dictionary",				-- Dictionary
		"tzachar/cmp-fuzzy-path",				-- File paths
		"tzachar/cmp-fuzzy-buffer",				-- Buffer text 
		after = { "hrsh7th/nvim-cmp" },			-- Autocompletion framework
	})
	use "nvim-lua/plenary.nvim"							-- Utils
	use "mfussenegger/nvim-dap"							-- Debug Adapter Protocol client
	use "simrat39/rust-tools.nvim"						-- Rust tools
	use {"nvim-telescope/telescope.nvim",				-- fuzzy finder
		branch = "0.1.x"}
	use {'romgrk/fzy-lua-native', run = 'make'}
	use "simrat39/symbols-outline.nvim"					-- Structure view		TODO: Setup keybindings
	use "romainl/vim-cool"								-- Disable search highlighting automatically	TODO: Check back, this may be native
	use "luochen1990/rainbow"							-- Rainbow brackets
	use "norcalli/nvim-colorizer.lua"					-- Highlight colours
	use "eapache/auto-pairs"							-- Make inserting brackets nicer, fork of jiangmiao/auto-pairs
	use "DanilaMihailov/beacon.nvim"					-- TODO: Dim sometimes,
	use "numToStr/Comment.nvim"							-- Commenting

	-- keep at the end
	if packer_bootstrap then		-- If packer was just installed run sync so it installs all the other plugins
		require("packer").sync()
	end
end)
