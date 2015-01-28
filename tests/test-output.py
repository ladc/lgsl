import sys
import os
import re
import subprocess
from glob import glob

test_dir = "tests"
luajit_exec = "luajit"
env = os.environ.copy()
env['LUA_PATH']= "./?.lua;;"

if not os.path.isdir("tests/log"):
    try:
        print "Creating directory tests/log..."
        os.mkdir("tests/log")
    except:
        print "Error creating directory tests/log."
        sys.exit(1)

for filename in glob("tests/log/*"):
    os.remove(filename)

try:
	subprocess.check_call([luajit_exec, "-e", ""])
except:
	print "Error calling luajit."
	print "Please make sure that luajit executable is in the current PATH."
	sys.exit(1)

def get_reference_text(dirpath, testname):
    with open(os.path.join(dirpath, testname + ".expect"), "r") as f:
        return f.read()

for dirpath, dirnames, filenames in os.walk(test_dir):
    for filename in sorted(filenames):
        m = re.match(r'([^.]+)\.lua$', filename)
        if m:
            fullname = os.path.join(dirpath, filename)
            testname = m.group(1)
            out_tst = None
            run_error = None
            try:
                process = subprocess.Popen([luajit_exec, fullname], stdout=subprocess.PIPE, stderr=subprocess.PIPE, env=env)
                out_tst, out_errors = process.communicate()
            except subprocess.CalledProcessError:
                run_error = "fail to run"
            try:
                out_ref = get_reference_text(dirpath, testname)
            except IOError:
                run_error = "missing expect file"
            led, msg = None, None
            if run_error:
                led, msg = "*", run_error
            elif out_tst == out_ref:
                if out_tst in ["", "\n", "\r\n"] or not out_tst:
                    led, msg = "-", "pass / no output"
                else:
                    led, msg = " ", "pass"
            else:
                led, msg = "*", "fail"
                log = open("tests/log/%s.output.diff" % testname, "w")
                log.write("*** reference ***\n%s\n" % out_ref)
                log.write("*** test program ***\n%s\n" % out_tst)
                log.close()

            print("%s %-24s %s" % (led, testname, msg))
