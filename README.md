Test ROMs that test the behavior of Gameboy stop instruction.

# stop.gb

stop.gb will compute the divider register and how far it is toward
incrementing, execute a stop (which will wait for joypad input) and
then check the divider register again.

On all tested consoles (DMG, MGB, GBC, GBA), this rom will output

```
00 44
00 60

Passed
```

# stop\_ly.gb

stop\_ly.gb will compute the LY register and how far it is toward
incrementing, execute a stop (which will wait for joypad input)
and then check LY again.

On DMG and MGB, this rom will output

```
90 04
55 5C

Passed
```

On GBC and GBA, the first line will be `90 04`, but the second line
will depend on when you press the button.
