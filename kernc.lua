
package.path = "/usr/local/share/kernc/?.lua;" .. package.path


pp = require("kernpp")


--- kernc.lua


local link_dirs = {}


local apps = {};
local include_dirs = {"./include", ".", "/usr/include"};
local link_dirs = {}
local link_libs = {}
local  build_files  = {}
local output_file = "a.out"

local mode = ""



-- opening logic
if (arg[1] == nil or arg[2] == nil) then
    print("usage: kernc  -f <files>  -o <output>")
    return
end

if (arg[1] == "-v") then
    print("kernc  v.1.0.0")
return
end





for i = 1, #arg do
    
    -- -ldir
    if arg[i] == "-ldir" then
        for j = i + 1, #arg do
            if arg[j]:sub(1,1) == "-" then
                break
            end
            table.insert(link_dirs, arg[j])
        end
    end

    -- -l
    if arg[i] == "-l" then
        for j = i + 1, #arg do
            if arg[j]:sub(1,1) == "-" then
                break
            end
            table.insert(link_libs, arg[j])
        end
    end

    -- -i
    if arg[i] == "-i" then
        for j = i + 1, #arg do
            if arg[j]:sub(1,1) == "-" then
                break
            end
            table.insert(include_dirs, arg[j])
        end
    end

    -- -f
    if arg[i] == "-f" then
        for j = i + 1, #arg do
            if arg[j]:sub(1,1) == "-" then
                break
            end
            table.insert(build_files, arg[j])
        end
    end
    
    
if arg[i] == "-static" then
    mode = "-static"
end

if arg[i] == "-shared" then
    shared_link = true
    mode = "-shared -fPIC"
end

    
    

end





for i = 1, #arg do
if arg[i] == "-o"  then
        output_file = arg[i+1] or "a.out"
    end
    
    
    
    
    
end


for i = 1, #arg do
    if arg[i] == "-app" then
        for j = i + 1, #arg do
            if arg[j]:sub(1,1) == "-" then
                break
            end

            -- load the script file
            local chunk, err = loadfile(arg[j])
            if not chunk then
                error("Failed to load app script: " .. err)
            end

            -- run the script; it must return a function
            local pp = chunk()
            if type(pp) ~= "function" then
                error("App script did not return a function: " .. arg[j])
            end

            -- store the function for later use
            table.insert(apps, pp)
        end
    end
    
    
end



for i=1,#build_files do 
  
  local file = io.open(build_files[i],"r")
local test = file:read("*a");
file:close();


--write to output file

local str=  pp(build_files[i],test,include_dirs,apps)

local out = io.open(build_files[i] .. ".c","w")
out:write(str);
out:close();


end

local files = ""



local link_dir_str = ""
local link_lib_str = ""

for i = 1, #link_dirs do
    link_dir_str = link_dir_str .. " -L" .. link_dirs[i]
end



for i = 1, #link_libs do
    link_lib_str = link_lib_str .. " -l" .. link_libs[i]
end



for  i=1,#build_files do 
  files = files ..  build_files[i] .. ".c "
  end


os.execute("gcc " .. files .. " -o  " .. output_file .. link_dir_str .. link_lib_str  .. "   " .. mode)

for i=1,#build_files do 
os.execute("rm " .. build_files[i] .. ".c" )

end





