vim.filetype.add({
	extension = {
		deb = "debate",
		adj = "debate"
	}
})

vim.api.nvim_create_autocmd( 'BufWinEnter', { pattern = "*.deb", callback = function()
	vim.opt.list = false
	vim.opt.number = false
	vim.opt.laststatus = 0
	vim.opt.rulerformat = "%7(%-03{g:debate_mode} %P%)"
	vim.cmd(":silent !gsettings set org.gnome.desktop.interface color-scheme prefer-light")	-- Gnome console can be a pain
	vim.api.nvim_create_autocmd( 'VimLeavePre', {command=":silent !gsettings set org.gnome.desktop.interface color-scheme prefer-dark"})
	vim.opt.wrap = true
	vim.opt.conceallevel = 3
	vim.cmd("vnew +set\\ syntax=debate %.adj")		-- Not quite sure why it doesn't detect syntax automatically

	vim.g.debate_mode = " "	-- It's a single space so it takes up space in the ruler

	-- 	This function ensures that wherever I move the cursor it inserts the
	-- relevant keyword, so maintains the same syntax highlighting until
	-- I manually change it by typing the keyword.

		-- When the cursor inserts in a new location,
	vim.api.nvim_create_autocmd( 'InsertEnter', {callback = function()	--	(I know this doesn't work if I use arrow keys, but I don't and I can change back to normal and then insert mode if I need to)

			-- check if it matches the current mode
		syntax = vim.inspect_pos(nil, nil, nil, {syntax=true})['syntax'][1];
		if (syntax and syntax['hl_group'] ~= "debate_" .. vim.g.debate_mode and vim.g.debate_mode ~= " ") then -- indexes start at 1, get the lowest level of syntax which is the speaker

				-- insert the keyword
			row, col = unpack(vim.api.nvim_win_get_cursor(0))
			if row ~= 1 then vim.api.nvim_buf_set_lines(0, row-1, row-1, true, {""}) else row = row -1 end	-- on a line below to avoid splitting text
			vim.api.nvim_buf_set_text(0, row, col, row, col,
				{ ";;" .. vim.g.debate_mode .. " " })

				-- then find the next keyword, and if there's any text in between
			local only_whitespace
			local keyword = "no keyword"
			local new_row, new_col
			if vim.fn.search(";;...\\=", "Wz") ~= 0 then
				new_row, new_col = unpack(vim.api.nvim_win_get_cursor(0))
				only_whitespace = string.match(table.concat(
					vim.api.nvim_buf_get_text(0, row, col+string.len(keyword)+2, new_row-1, new_col, {})),
					"\\S")

				keyword = vim.fn.expand("<cword>")
			end

				-- if there is text between
			if (not only_whitespace and keyword ~= "no keyword") then
					-- 	insert the keyword for the original highlight group on a
					-- line below, so the remaining text isn't recoloured
				later_row, later_col = unpack(vim.api.nvim_win_get_cursor(0))
				vim.api.nvim_buf_set_text(0,
					row, col+string.len(keyword)+3, row, col+string.len(keyword)+3,
					{ "", ";;" .. string.sub(syntax['hl_group'], 8) })

				-- If it's just whitespace until an identical keyword
			elseif (only_whitespace and keyword == vim.g.debate_mode) then
					-- remove the later occurrence of the keyword
				vim.api.nvim_buf_set_text(0,
					new_row-1, new_col, new_row-1, new_col + 3 + string.len(keyword),
					{})
			end

				-- finally, fix the cursor position
			vim.api.nvim_win_set_cursor(0, {row+1, col+7})
			vim.v.char = "and don't reset the cursor at the end of the autocommand"
		end
	end})


	-- Update the current speaker when a marker is manually set
	vim.keymap.set("i", ";;1a", ";;1a <Esc>:let g:debate_mode=\"1a\"<Enter>li", {noremap=true})
	vim.keymap.set("i", ";;2a", ";;2a <Esc>:let g:debate_mode=\"2a\"<Enter>li", {noremap=true})
	vim.keymap.set("i", ";;3a", ";;3a <Esc>:let g:debate_mode=\"3a\"<Enter>li", {noremap=true})

	vim.keymap.set("i", ";;1n", ";;1n <Esc>:let g:debate_mode=\"1n\"<Enter>li", {noremap=true})
	vim.keymap.set("i", ";;2n", ";;2n <Esc>:let g:debate_mode=\"2n\"<Enter>li", {noremap=true})
	vim.keymap.set("i", ";;3n", ";;3n <Esc>:let g:debate_mode=\"3n\"<Enter>li", {noremap=true})

	vim.keymap.set("i", ";;PM", ";;PM <Esc>:let g:debate_mode=\"PM\"<Enter>li", {noremap=true})
	vim.keymap.set("i", ";;DPM", ";;DPM <Esc>:let g:debate_mode=\"DPM\"<Enter>li", {noremap=true})
	vim.keymap.set("i", ";;LO", ";;LO <Esc>:let g:debate_mode=\"LO\"<Enter>li", {noremap=true})
	vim.keymap.set("i", ";;DLO", ";;DLO <Esc>:let g:debate_mode=\"DLO\"<Enter>li", {noremap=true})
	vim.keymap.set("i", ";;MP", ";;MP <Esc>:let g:debate_mode=\"MP\"<Enter>li", {noremap=true})
	vim.keymap.set("i", ";;GW", ";;GW <Esc>:let g:debate_mode=\"GW\"<Enter>li", {noremap=true})
	vim.keymap.set("i", ";;MO", ";;MO <Esc>:let g:debate_mode=\"MO\"<Enter>li", {noremap=true})
	vim.keymap.set("i", ";;OW", ";;OW <Esc>:let g:debate_mode=\"OW\"<Enter>li", {noremap=true})

	vim.keymap.set("i", ";;F", ";;F <Esc>:let g:debate_mode=\"F\"<Enter>i", {noremap=true})
	vim.keymap.set("i", ";;R", ";;R <Esc>:let g:debate_mode=\"R\"<Enter>i", {noremap=true})
end})
