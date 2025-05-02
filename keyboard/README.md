# Using QMK

[online documentation](https://docs.qmk.fm/#/)

## install qmk

### install pip venv

```
apt install python3.xx-venv
```
and
```
python3 -m venv $HOME/venv
```

### install qml in this venv

```
[julien@Z230] venv $ ./bin/pip install qmk
Collecting qmk
  Downloading qmk-1.1.7-py2.py3-none-any.whl (14 kB)
Collecting hid
  Downloading hid-1.0.7-py3-none-any.whl (4.9 kB)
Collecting milc>=1.9.0
[...]
Collecting termcolor>=1.1.0
  Downloading termcolor-3.1.0-py3-none-any.whl (7.7 kB)
Installing collected packages: spinners, pyserial, hjson, hid, typing-extensions, types-colorama, termcolor, six, rpds-py, pyusb, pygments, platformdirs, pillow, dotty-dict, colorama, attrs, argcomplete, referencing, log_symbols, jsonschema-specifications, halo, milc, jsonschema, qmk
  DEPRECATION: halo is being installed [...]
  [...]
Successfully installed argcom[...]
```

```
[julien@Z230] venv $ ./bin/qmk setup --home /opt/qmk
☒ Could not find qmk_firmware!
Would you like to clone qmk/qmk_firmware to /opt/qmk? [y/n] y
Cloning into '/opt/qmk'...
Updating files:  90% (20013/22020)
Updating files:  91% (20039/22020)
Updating files:  92% (20259/22020)
Updating files:  93% (20479/22020)
Updating files:  94% (20699/22020)
Updating files:  95% (20919/22020)
Updating files:  96% (21140/22020)
Updating files:  97% (21360/22020)
Updating files:  98% (21580/22020)
[...]
Submodule path 'lib/vusb': checked out '819dbc1e5d5926b17e27e00ca6d3d2988adae04e'
Ψ Successfully cloned https://github.com/qmk/qmk_firmware to /opt/qmk!
Ψ Added https://github.com/qmk/qmk_firmware as remote upstream.
Would you like to set /opt/qmk as your QMK home? [y/n] y
Ψ Wrote configuration to /home/julien/.config/qmk/qmk.ini
<class 'FileNotFoundError'>
☒ [Errno 2] No such file or directory: 'bin/qmk'
Traceback (most recent call last):
  File "/home/julien/venv/lib/python3.11/site-packages/milc/milc.py", line 609, in __call__
    return self.__call__()
           ^^^^^^^^^^^^^^^
  File "/home/julien/venv/lib/python3.11/site-packages/milc/milc.py", line 614, in __call__
    return self._subcommand(self)
           ^^^^^^^^^^^^^^^^^^^^^^
  File "/home/julien/venv/lib/python3.11/site-packages/qmk_cli/subcommands/setup.py", line 140, in setup
    cli.run(doctor_command, stdin=None, capture_output=False, cwd=cli.args.home)
  File "/home/julien/venv/lib/python3.11/site-packages/milc/milc.py", line 196, in run
    return subprocess.run(command, **kwargs)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.11/subprocess.py", line 548, in run
    with Popen(*popenargs, **kwargs) as process:
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.11/subprocess.py", line 1024, in __init__
    self._execute_child(args, executable, preexec_fn, close_fds,
  File "/usr/lib/python3.11/subprocess.py", line 1901, in _execute_child
    raise child_exception_type(errno_num, err_msg, err_filename)
FileNotFoundError: [Errno 2] No such file or directory: 'bin/qmk'
```

https://docs.qmk.fm/newbs_getting_started
[julien@Z230] venv $ export PATH=/usr/local/bin:/usr/bin:/bin:$HOME/.local/bin

ln -s $(realpath ./bin/qmk) ~/.local/bin/qmk
export PATH=/usr/local/bin:/usr/bin:/bin:$HOME/.local/bin

Ψ CLI installed in virtualenv.
☒ Can't find arm-none-eabi-gcc in your path.
☒ Can't find avr-gcc in your path.
☒ Can't find avrdude in your path.
☒ Can't find dfu-programmer in your path.
☒ Can't find dfu-util in your path.
Would you like to install dependencies? [Y/n] Y
[sudo] password for julien: 
julien is not in the sudoers file.
☒ Can't find arm-none-eabi-gcc in your path.
☒ Can't find avr-gcc in your path.
☒ Can't find avrdude in your path.
☒ Can't find dfu-programmer in your path.
☒ Can't find dfu-util in your path.
⚠ Unknown version for arm-none-eabi-gcc
⚠ Unknown version for avr-gcc
⚠ Unknown version for avrdude
⚠ Unknown version for dfu-programmer
⚠ Unknown version for dfu-util
```

## OLD

- python3 -m pip install --user qmk
=> error: externally-managed-environment

```
    If you wish to install a non-Debian-packaged Python package,
    create a virtual environment using python3 -m venv path/to/venv.
    Then use path/to/venv/bin/python and path/to/venv/bin/pip. Make
    sure you have python3-full installed.
 ``` 


shorting RESET / GROUND

[ 1478.229520] usb 2-11.2: USB disconnect, device number 38
[ 1480.243227] usb 2-11.2: new full-speed USB device number 39 using xhci_hcd
[ 1480.349542] usb 2-11.2: New USB device found, idVendor=1b4f, idProduct=9205, bcdDevice= 0.01
[ 1480.349557] usb 2-11.2: New USB device strings: Mfr=2, Product=1, SerialNumber=0
[ 1480.349563] usb 2-11.2: Product: Pro Micro 5V  
[ 1480.349568] usb 2-11.2: Manufacturer: SparkFun Electronics
[ 1480.358227] cdc_acm 2-11.2:1.0: ttyACM0: USB ACM device


Flashing for bootloader: caterina
Waiting for USB serial port - reset your controller now (Ctrl+C to cancel)........
Device /dev/ttyACM0 has appeared; assuming it is the controller.
Waiting for /dev/ttyACM0 to become writable.
Reading 24462 bytes for flash from input file atreus_promicro_atreus_promicro_layout_pcb_up_2025-05-02.hex
Writing 24462 bytes to flash
Writing | ################################################## | 100% 1.88 s 
Reading | ################################################## | 100% 0.22 s 
24462 bytes of flash verified

Avrdude done.  Thank you.




## OLD

```
julien@thinkpad:~/projects/config$ which qmk 
/home/julien/.local/bin/qmk
```

```
qmk setup 
# qmk compile -kb atreus/promicro -km default
qmk compile -c ~/Downloads/jbo.json
qmk flash -c ~/Downloads/jbo.json
```
## OLD
To flash a new layout:

- use the web interface under  https://config.qmk.fm/#/atreus/promicro/LAYOUT to design the layout.
- you can compile the firmware from the web site
- this is slow
- download firmare and flash with
```
./flash.sh ~/Downloads/atreus_promicro_jbo.hex
```

do it yourself build:
install qmk with:
```
python3 -m pip install -qmk
```
and always enter yes. 
see https://beta.docs.qmk.fm/tutorial/newbs_getting_started
