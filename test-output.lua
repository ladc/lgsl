#!/usr/bin/env luajit
local lfs = require("lfs")
local test_dir = "tests"
local log_dir = test_dir.."/log"
package.path = "./?.lua;"..package.path

local function reference_output(dirpath,testname)
  local f, err = io.open(dirpath.."/"..testname..".expect")
  if err then return nil, err end
  local ref = f:read("*a")
  f:close()
  return ref
end

local log_attr = lfs.attributes(log_dir)
if not (log_attr and log_attr.mode=="directory") then
  local ok, err = lfs.mkdir(log_dir)
  if not ok then
    print("Error creating directory "..log_dir..": ",err)
    os.exit(1)
  end
end

local record
do
  local old_print, old_write = print, io.write
  local out_buffer
  local function rec_print(...)
    local args = {...}
    for i,v in ipairs(args) do
      args[i]=tostring(v)
    end
    out_buffer = (out_buffer or "")..table.concat(args,"\t").."\n"
  end
  local function rec_write(...)
    out_buffer = (out_buffer or "")..table.concat({...})
  end
  record = function(cmd)
    if cmd=="stop" then
      print, io.write = old_print, old_write
      return out_buffer
    else
      out_buffer = "" 
      print, io.write = rec_print, rec_write
    end
  end
end

local status = 0
for testfile in lfs.dir(test_dir) do
  local fullname = test_dir.."/"..testfile
  if lfs.attributes(fullname).mode=="file" and testfile:find("%.lua$") then
    local err
    -- Try to load the test file
    local loaded_test, load_err = loadfile(fullname)
    if load_err then
      err = "failed to load: "..load_err
    end
    -- Try to read the reference output 
    local testname = testfile:match("(%S+)%.lua$")
    local out_ref, ref_err = reference_output(test_dir,testname)
    if ref_err then
      err = "missing expect file: "..ref_err
    end
    -- Try to run the test file
    local out_log
    if not err then
      record()
      local run_ok, run_err = pcall(loaded_test)
      out_log = record("stop")
      if not run_ok then
        err = "failed to run: "..run_err
      end
    end
    local led, msg
    if not err and out_log == out_ref then
      if out_log:find("^\r?\n?$") then
        led, msg = "-", "pass / no output"
      else
        led, msg = " ", "pass"
      end
    else
      led, msg = "*","fail"
      status = 1
      if not err then
        local log = io.open(log_dir.."/"..testname..".output.diff", "w")
        if not log then err = "Could not open log file for writing."
        else
          log:write("*** reference ***\n",out_ref,"\n")
          log:write("*** test program ***\n",out_log,"\n")
          log:close()
        end
      end
    end
    print(string.format("%s %-24s %-6s %s",led, testname, msg, err or ""))
  end
end
os.exit(status)
