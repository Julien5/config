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
