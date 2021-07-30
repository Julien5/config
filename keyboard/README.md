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
git clone https://github.com/qmk/qmk_firmware.git
cd qmk_firmware/
python3 -m pip install -U -r /home/julien/projects/config/keyboard/qmk_firmware/requirements.txt
make git-submodule
```
to be continued.
