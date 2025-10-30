local Utils = {}

--@return table
function Utils.extend_opts(opts, newopts)
	return vim.tbl_extend("keep", opts, newopts)
end

return Utils
