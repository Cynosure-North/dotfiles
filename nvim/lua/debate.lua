vim.api.nvim_create_autocmd( 'BufNewFile', { pattern = "*.deb", command = ":vnew %.adj"})

-- Syntax highlight
--		maybe add filetype
--		maybe just use typed characters which are concealed
--			set conceallevel
--			that way I don't have to save highlights to a separate file
--		https://stackoverflow.com/questions/33651643/how-to-have-a-vim-multiline-syntax-highlight-clause
--		https://vim.fandom.com/wiki/Creating_your_own_syntax_files
-- Delimit speeches
-- 		right align opposition
-- 			Set folding
