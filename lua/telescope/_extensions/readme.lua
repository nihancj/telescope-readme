local telescope = require("telescope")
local main = require("telescope._extensions.readme.main")

return telescope.register_extension({
	exports = { readme = main },
})
