set print pretty on
set target-async on

file blink.elf

define reset
       target extended-remote localhost:3333

       monitor reset

       load

       monitor reg sp 0x20010000
       monitor reg pc 0x00000000

       monitor reg

end