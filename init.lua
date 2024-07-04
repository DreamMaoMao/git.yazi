local function string_split(input,delimiter)

	local result = {}

	for match in (input..delimiter):gmatch("(.-)"..delimiter) do
	        table.insert(result, match)
	end
	return result
end

local function set_status_color(status)
	if status == nil then
		return "#6cc749"
	elseif status == "M" then
		return "#ec613f"
	elseif status == "A" then
		return "#ec613f"
	elseif status == "I" then
		return "#8a6ae5"
	elseif status == "U" then
		return "#D4BB91"
	end
	
end

local function make_git_table(git_status_str)
	local file_table = {}
	local git_status
	local is_dirty = false
	local split_table = string_split(git_status_str:sub(1,-2),"\n")
	for _, value in ipairs(split_table) do
		split_value = string_split(value," ")
		if split_value[#split_value - 1] == "" then
			split_value = string_split(value,"  ")
		end

		if split_value[#split_value - 1] == "??" then 
			git_status = "U"
			is_dirty = true
		elseif split_value[#split_value - 1] == "!!" then
			git_status = "I"
		else
			git_status = split_value[#split_value - 1]
			is_dirty = true
		end
		file_table[split_value[#split_value]] = git_status
	end
	return file_table,is_dirty
end

local save = ya.sync(function(st, cwd, git_branch,git_status_str,folder_size,git_file_status,git_is_dirty)
	if cx.active.current.cwd == Url(cwd) then
		st.git_branch = git_branch
		st.git_status_str = git_status_str
		st.folder_size = folder_size
		st.git_file_status = git_file_status
		st.git_is_dirty = git_is_dirty
		ya.render()
	end
end)

local enable_file_size = ya.sync(function(st)
	return st.opt_enable_folder_size
end)

local set_opts_default = ya.sync(function(state)
	if (state.opt_folder_size_ignore == nil) then
		state.opt_folder_size_ignore = {}
	end
	if (state.opt_gitstatus_ignore == nil) then
		state.opt_gitstatus_ignore = {}
	end
	if (state.opt_enable_folder_size == nil) then
		state.opt_enable_folder_size = false
	end
end)

return {
	setup = function(st,opts)

		set_opts_default()

		if (opts ~= nil and opts.folder_size_ignore ~= nil ) then
			st.opt_folder_size_ignore  = opts.folder_size_ignore
		end
		if (opts ~= nil and opts.gitstatus_ignore ~= nil ) then
			st.opt_gitstatus_ignore  = opts.gitstatus_ignore
		end
		if (opts ~= nil and opts.enable_folder_size ~= nil ) then
			st.opt_enable_folder_size  = opts.enable_folder_size
		end

		function Folder:linemode(area, files)
			local mode = cx.active.conf.linemode
		
			local lines = {}
			local git_span = {}
			for _, f in ipairs(files) do
				local spans = { ui.Span(" ") }
				if st.git_status_str ~= nil and st.git_status_str ~= "" then
					local name = f.cha.is_dir and f.name:gsub("\r", "?", 1).."/" or f.name:gsub("\r", "?", 1)
					local color = set_status_color(st.git_file_status[name])
					if f:is_hovered() then
						git_span = st.git_file_status[name] and ui.Span(st.git_file_status[name]) or ui.Span("✓")	
					else
						git_span = st.git_file_status[name] and ui.Span(st.git_file_status[name]):fg(color) or ui.Span("✓"):fg(color)		
					end
				end
				if mode == "size" then
					local size = f:size()
					spans[#spans + 1] = ui.Span(size and ya.readable_size(size) or "")
				elseif mode == "mtime" then
					local time = f.cha.modified
					spans[#spans + 1] = ui.Span(time and os.date("%y-%m-%d %H:%M", time // 1) or "")
				elseif mode == "permissions" then
					spans[#spans + 1] = ui.Span(f.cha:permissions() or "")
				end
				
				spans[#spans + 1] = ui.Span(" ")
				spans[#spans + 1] = git_span
				spans[#spans + 1] = ui.Span(" ")
				lines[#lines + 1] = ui.Line(spans)
			end
			return ui.Paragraph(area, lines):align(ui.Paragraph.RIGHT)
		end

		function Header:cwd(max)
			local git_span = {}
			local cwd = cx.active.current.cwd
			local ignore_caculate_size = false
			local ignore_gitstatus = false

			for _, value in ipairs(st.opt_folder_size_ignore) do
				if value == tostring(cwd) then
					ignore_caculate_size = true
				end
			end

			for _, value in ipairs(st.opt_gitstatus_ignore) do
				if value == tostring(cwd) then
					ignore_gitstatus = true
				end
			end

			local folder_size_span = (st.folder_size ~= nil and st.folder_size ~= "") and ui.Span(" [".. st.folder_size  .."]")  or {}
			if st.cwd ~= cwd then
				st.cwd = cwd
				ya.manager_emit("plugin", { st._name, args = ya.quote(tostring(cwd)).." "..tostring(ignore_caculate_size).." ".. tostring(ignore_gitstatus) })
			else
				local git_is_dirty = st.git_is_dirty  and "*" or ""
				git_span = (st.git_branch and st.git_branch ~= "") and ui.Span(" <".. st.git_branch .. git_is_dirty .. ">"):fg("#c6ca4a") or {}				
			end

			local s = ya.readable_path(tostring(cx.active.current.cwd)) .. self:flags()

			return ui.Line{ui.Span(ya.truncate(s, { max = max, rtl = true }) ):style(THEME.manager.cwd),git_span,folder_size_span}
		end
	end,

	entry = function(_, args)
		local output
		local git_is_dirty

		local git_branch  = ""
		if args[3] ~= "true" then
			local command = "git symbolic-ref HEAD 2> /dev/null" 
			local file = io.popen(command, "r")
			output = file:read("*a") 
			file:close()
		else
			output = nil
		end
		if output ~= nil and  output ~= "" then
			local split_output = string_split(output:sub(1,-2),"/")
			
			git_branch = split_output[3]
		end
		
		local git_status_str = ""
		local git_file_status = nil
		if args[3] ~= "true" then
			local command = "git status --ignored -s --ignore-submodules=dirty 2> /dev/null" 
			local file = io.popen(command, "r")
			output = file:read("*a") 
			file:close()
		else
			output = nil
		end
		if output ~= nil and  output ~= "" then
			git_status_str = output
			git_file_status,git_is_dirty = make_git_table(git_status_str)
		end

		local folder_size = ""
		if args[2] ~= "true" and enable_file_size() then
			output = Command("du"):args({"-sh",args[1].."/"}):output()
		else
			output = nil
		end
		if output then
			local split_output = string_split(output.stdout,"\t")
			folder_size = split_output[1]
		end		

		save(args[1], git_branch,git_status_str,folder_size,git_file_status,git_is_dirty)
	end,
}