local demo_list = {} -- demo list per group. demo_list["groupname"] = {demo1, demo2}
local demo_flatlist = {} -- demo flat list. demo_flatlist[i] = "demoname"
local group_flatlist = {} -- group flat list. group_flatlist[i] = "groupname"

local noop = function() end

-- Load a demo file using require(name), and store it in the demo_list.
-- Add the demo and group names to their respective flatlists.
local function load_demo_file(name,verbose)
   local write = verbose and io.write or noop
   write("Load demo ",name,": ")
   local record = require(name)
   assert(type(record)=="table","Demo must return table: "..name)
   local group, info = record[1], record[2]
   local section = demo_list[group]
   if not section then
      section = {}
      demo_list[group] = section
      group_flatlist[#group_flatlist+1]=group
   end
   for k, v in ipairs(info) do
      v.fname=name
      section[#section+1]=v
      write(v.name," ")
      demo_flatlist[#demo_flatlist+1]=v.name
   end
   write("\n")
end

-- List of files that contain demo functions, and that will be required.
local demo_files = {
  'fft', 'bspline', 'wave-particle', 'plot', 'fractals', 
  'ode', 'nlinfit', 'integ', 'anim', 'linfit', 
  'sf', 'vegas', 
}

local function demolist_string()
   return 'demos = {"'..table.concat(demo_flatlist,'","')..'"}\n'
end

-- Print overview of demos per group.
local function print_demos_list()
   for _,group in ipairs(group_flatlist) do
      io.write('*** ', group, '\n')
      for k, v in ipairs(demo_list[group]) do
         print(v.name .. ' (from '..v.fname..') ' .. v.description)
      end
      print ''
      print("***************************************************")
   end
   print("Type demos.run(\"name\") to execute demos that match \"name\".")
   print("For example type demos.run(\"wave\") for wave particle demo.")
   print("Type demos.run{\"name1\", \"name2\"} to run multiple demos.")
   print ''
   print(demolist_string())
   print ''
end

-- Check if the list contains anything that item matches.
local function listcontains(list,item)
   if type(list)=="string" then
      return (item:find(list))
   end
   for k,v in ipairs(list) do
      if item:find(v) then return true end
   end
   return false
end

-- Run all demos that match the list of demo names (e.g. anim will match anim1
-- and anim2); verbosely by default.
local function rundemos(dlist, quiet)
   local write,flush = io.write,io.flush
   if quiet then write,flush = noop,noop end
   if not dlist then write(demolist_string()) end
   for i, group in ipairs(group_flatlist) do
      local categoryshown=false
      for j,v in ipairs(demo_list[group]) do
         if not dlist or listcontains(dlist,v.name) then
            if not categoryshown then 
               categoryshown=true    
               write("Category: ",group,"\n")
            end
            write(string.format("  %s.%s: %s\n",v.fname,v.name,v.description))
            flush()
            v.f()
         end
      end
   end
end

-- local alldemos = {"fft1", "fft2", "fft3", "bspline1", "wave", "gaussian", "fftplot", "vonkoch", "levyc", "pitags", "pitaga", "nlfit1", "nlfit2", "numint", "anim1", "anim2", "anim3", "linfit1", "linfit2", "sf1", "sf2", "vegas", "sphere"}

if pcall(debug.getlocal, 4, 1) then -- loaded as library
  for i, name in ipairs(demo_files) do
    load_demo_file("lgsl.demos."..name, false) -- load quietly
  end
  return {run = rundemos, show = print_demos_list, load = load_demo_file}
else -- run from command line
  for i, name in ipairs(demo_files) do
    load_demo_file(name, true)
  end
  if arg[1] then
    rundemos(arg)
  else
    rundemos()
  end
end
