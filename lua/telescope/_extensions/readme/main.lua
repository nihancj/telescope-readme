local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local themes = require("telescope.themes")

local Scan = require("plenary.scandir")
local path = vim.fn.stdpath("data") .. "/lazy"
local readmes = Scan.scan_dir(path, { hidden = false, depth = 2, only_dirs = false, search_pattern = "README.md" })

local readme = function(opts)
	opts = themes["get_ivy"]()
	pickers
		.new(opts, {
			prompt_title = "README",
			finder = finders.new_table({
				results = readmes,
				entry_maker = function(entry)
					return {
						value = entry,
						display = string.gsub(vim.fs.dirname(entry), path .. "/", ""),
						ordinal = entry,
					}
				end,
			}),
			previewer = conf.file_previewer(opts),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					vim.cmd("view" .. selection["value"])
				end)
				return true
			end,
		})
		:find()
end
return readme
