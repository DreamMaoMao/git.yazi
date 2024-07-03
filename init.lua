local function string_split(input,delimiter)

	local result = {}

	for match in (input..delimiter):gmatch("(.-)"..delimiter) do
	        table.insert(result, match)
	end
	return result
end

local save = ya.sync(function(st, cwd, git_branch,git_is_dirty)
	if cx.active.current.cwd == Url(cwd) then
		st.git_branch = git_branch
		st.git_is_dirty = git_is_dirty
		ya.render()
	end
end)

return {
	setup = function(st)
		
		function Header:cwd(max)
			local cwd = cx.active.current.cwd
			local git_is_dirty = (st.git_is_dirty ~= "" and st.git_is_dirty ~= "") and "*" or ""
			local git_span = (st.git_branch and st.git_branch ~= "") and ui.Span(" <".. st.git_branch .. git_is_dirty .. ">"):fg("#c6ca4a") or {}
			local s = ya.readable_path(tostring(cx.active.current.cwd)) .. self:flags()
			if st.cwd ~= cwd then
				st.cwd = cwd
				ya.manager_emit("plugin", { st._name, args = ya.quote(tostring(cwd)) })
			end
			return ui.Line{ui.Span(ya.truncate(s, { max = max, rtl = true }) ):style(THEME.manager.cwd),git_span}
		end
	end,

	entry = function(_, args)
		local command = "git symbolic-ref HEAD 2> /dev/null" 
		local file = io.popen(command, "r")
		local output = file:read("*a") 
		file:close()

		local git_branch  = ""
		if output ~= nil and  output ~= "" then
			local split_output = string_split(output:sub(1,-2),"/")
			
			git_branch = split_output[3]
		end
		
		local git_is_dirty = ""
		local command = "git status -s --ignore-submodules=dirty 2> /dev/null" 
		local file = io.popen(command, "r")
		local output = file:read("*a") 
		file:close()
		if output ~= nil and  output ~= "" then
			
			git_is_dirty = output
		end

		save(args[1], git_branch,git_is_dirty)
	end,
}