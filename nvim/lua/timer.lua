
local function tick_down(count, callback)
	callback(count)
	if count ~= 0 then
		vim.defer_fn(function() tick_down(count-1, callback) end, 200)
	end
end

local function alert()
	tick_down(21, function(val)
		if val % 2 == 1 then vim.opt.cursorline = true
		else vim.opt.cursorline = false
		end
	end)
end

local function Prep_Timer(opts)
	local length
	if opts.args then
		num = tonumber(opts.args)
		if num ~= nil then length = num
		else length = 30
		end
	end

	print(string.format("%d minute timer started. Time now is %s.", length, vim.fn.strftime("%H:%M")))
	
	if length > 5 then vim.defer_fn(function() print("5 Minutes left") end, (length-5) * 1000 * 60) end
	vim.defer_fn(function() alert() print("Time's Up") end, length * 1000 * 60)
end

vim.api.nvim_create_user_command("Timer", Prep_Timer, { nargs = '?', desc = "A simple timer, in minutes" })
