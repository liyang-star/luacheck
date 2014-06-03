local warnings = {
   global = {
      access = "accessing undefined variable %s",
      set = "setting non-standard global variable %s"
   },
   redefined = {
      var = "variable %s was previously defined on line %s",
      arg = "variable %s was previously defined as an argument on line %s",
      loop = "variable %s was previously defined as a loop variable on line %s"
   },
   unused = {
      var = "unused variable %s",
      arg = "unused argument %s",
      loop = "unused loop variable %s",
      vararg = "unused variable length argument"
   },
   unused_value = {
      var = "value assigned to variable %s is unused",
      arg = "value of argument %s is unused",
      loop = "value of loop variable %s is unused"
   }
}

--- Formats a file report. 
local function format(report, color)
   local label = "Checking "..report.file
   local status

   if report.error then
      status = color ("%{bright}"..report.error:sub(1, 1):upper()..report.error:sub(2).." error")
   elseif report.total == 0 then
      status = color "%{bright}%{green}OK"
   else
      status = color "%{bright}%{red}Failure"
   end

   local buf = {label..(" "):rep(math.max(50 - #label, 1))..status}

   if not report.error and report.total > 0 then
      table.insert(buf, "")

      for i=1, report.total do
         local warning = report[i]
         local location = ("%s:%d:%d"):format(report.file, warning.line, warning.column)
         local message = warnings[warning.type][warning.subtype]:format(color("%{bright}"..warning.name), warning.prev_line)
         table.insert(buf, ("    %s: %s"):format(location, message))
      end

      table.insert(buf, "")
   end

   return table.concat(buf, "\n")
end

return format
