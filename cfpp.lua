
-- cflat preprocesser v1.1.0






-- include:



local INCLUDE_DIRS = {}

local preprocessors = {}
local included = {}



function process(test,curr_file)



local include_pattern = '#include%s*[<"]([^">]+)[">]'

test = test:gsub(include_pattern, function(inc)
    

    -- Let C compiler handle .h files
    if inc:match("%.h$") then
        return '#include "' .. inc .. '"\n'
    end

    -- Expand .cf files
    if inc:match("%.cf$") then
      
      
      -- if included do not
      if (included[inc] or inc ==  curr_file )  then 
        return ""
      end
       included[inc] = true
      
      
      
     -- Try direct open
local f = io.open(inc, "r")

-- Try relative to current file
if not f then
    local base = curr_file:match("(.*/)")
    if base then
        f = io.open(base .. inc, "r")
    end
end

-- Try include dirs
if not f then
    for _, dir in ipairs(INCLUDE_DIRS) do
        local path = dir .. "/" .. inc
        f = io.open(path, "r")
        if f then break end
    end
end


        if not f then
             print("Include not found: " .. inc)
            error("") 
            
        end

        local str = f:read("*a")
        f:close()

        str = process(str,curr_file)

       -- return '#line 1 "'..inc..'"\n' .. str .. '\n#line 1 "'..arg[1]..'"\n'\
       
       return str;
       
    end

    -- DEFAULT CASE: ignore unknown includes
    return ""
end)





-- process raii scopes
   
local format = "@(%b{})"

local str = test:gsub(format, function(block)
   -- block is "@{ ... }"
   -- We strip the '@{' (first two) and '}' (last one)
   local inner = block:sub(3, -2)

   -- If the block is empty or just whitespace, don't add RAII
   if inner:match("^%s*$") then
      return "{}"
   end

 local parsed = inner
     :gsub("return%s+([^;]+)", "ret(%1)")
     :gsub("break", "brk")
     :gsub("continue", "cont")

   return "{ raii_scope;" .. parsed .. "cleanup(); }"
end)


str = "#include<cflat/mfcu.h>\n" .. str



-- defineblock logic


  str = str:gsub(
    "#macro%s+([_%a][_%w]*)%(([^)]*)%)%s*(.-)#endm",
    function(name, param, body)
    
    local out = "#define " .. name .. "("  .. param .. ") \\\n"
    
    local lines = {}
for line in body:gmatch("([^\n]+)") do
    table.insert(lines, line)
end

for i=1,#lines -1 do 
  
if lines[i]:match("^%s*$") then
    lines[i] = "/* */\\"
    goto cont
end

  
  lines[i]  = lines[i] .. "\\"
  ::cont::
  end

  
  for i=1,#lines do 
    
    
    
    out = out .. lines[i] .. "\n"
 
    
    
    end
    
       return out
    end
)




for i=1,#preprocessors do 
  str = preprocessors[i](str)
  end


return str

end












function preprocess(curfile,str,include_dirs,apps) 
  INCLUDE_DIRS = include_dirs;
  preprocessors = apps;
  
  return process(str,curfile)
  
end


return preprocess;
