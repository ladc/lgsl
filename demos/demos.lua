
local demo_list = {}
local demo_flatlist={}

local function load_demo(name)
   io.write("Load demo ",name,": ")
   local record = require(name)
   assert(type(record)=="table","Demo must return table: "..name)
   local group, info = record[1], record[2]
   local section = demo_list[group]
   if not section then
      section = {}
      demo_list[group] = section
   end
   local i = #section
   for k, v in ipairs(info) do
      v.fname=name
      section[i+k] = v
      io.write(v.name," ")
      demo_flatlist[#demo_flatlist+1]=v.name
   end
   io.write("\n")
end

local function list2string(list)
  local t={}
  for k,v in ipairs(list) do t[k]=[["]]..v..[["]] end
  return table.concat(t,", ")
end

local demo_files = {
  'fft', 'bspline', 'wave-particle', 'plot', 'fractals', 
  'ode', 'nlinfit', 'integ', 'anim', 'linfit', 
-- 'contour', 'svg', 'graphics', 
  'sf', 'vegas', 
--  'gdt-lm'
}

for i, name in ipairs(demo_files) do
   load_demo(name)
end

io.write("demos = {",list2string(demo_flatlist),"}\n\n")

local function print_demos_list()
   for group, t in pairs(demo_list) do
      io.write('*** ', group, '\n')
      for k, v in ipairs(t) do
         print(v.fname.."."..v.name .. ' - ' .. v.description)
      end
      print ''
      print("***************************************************")
   end
   print("Type demo(<name>) to execute the demo.")
   print("For example type demo(\"wave\") for wave particle demo.")
   print ''
end

local function load_demo(name)
   for group, t in pairs(demo_list) do
      for k, entry in ipairs(t) do
         if entry.name == name then
            return entry
         end
      end
   end
end

local function listcontains(list,item)
  for k,v in ipairs(list) do
    if item:match(v) then return true end
  end
  return false
end

local function rundemos(dflist) -- Optional list of demofunction names or string.match regexps (eg. anim will match anim1 and anim2)
 for group, d in pairs(demo_list) do
    local categoryshown=false
    for i,v in ipairs(d) do
      if not dflist or listcontains(dflist,v.name) then
        if not categoryshown then 
          categoryshown=true    
          io.write("Category: ",group,"\n")
        end
        io.write(string.format("  %s.%s: %s\n",v.fname,v.name,v.description),"\n")
        io.flush()
        v.f()
      end
    end
 end
end

-- local alldemos = {"fft1", "fft2", "fft3", "bspline1", "wave", "gaussian", "fftplot", "vonkoch", "levyc", "pitags", "pitaga", "nlfit1", "nlfit2", "numint", "anim1", "anim2", "anim3", "linfit1", "linfit2", "sf1", "sf2", "vegas", "sphere"}

local demos = {"fft1", "fft2", "fft3", "bspline1", "wave", "gaussian", "fftplot", "vonkoch", "levyc", "pitags", "pitaga", "nlfit1", "nlfit2", "numint", "anim1", "anim2", "anim3", "linfit1", "linfit2", "sf1", "sf2", "vegas", "sphere"}
rundemos(arg[1] and arg or demos)

return {
   list = print_demos_list,
   load = load_demo,
   rundemos=rundemos
}
