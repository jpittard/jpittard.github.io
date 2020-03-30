If you have set up a virtual environment at /opt/scripts/inventory/inv-venv,
inside a script, you need to set site-packages to the virtual environment,
and then prepend the path to the relevant bin dir for python.

```
export PYTHONPATH=/opt/scripts/inventory/inv-venv/lib/python3.6/site-packages
export PATH="/opt/rh/rh-python36/root/usr/bin:$PATH"
python3.6 do_something.py 
```

Don't try to call the initialization script from within bash. It will create another shell.
