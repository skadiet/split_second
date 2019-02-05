*How to Play:*

There are two choices:
1. You can download the split_second.nes file and play it in your favorite NES emulator.
2. You can build split_second.nes yourself by cloning the git repo and using NESASM to compile split_second.asm.


*Description:*

Split Second was originally introduced to the world by Parker Brothers in 1980.  The game itself was constructed with dark red plastic and had an old fashion 1970s “Star Wars-ish” feel to it. It had a simple display which only consisted of an array of red lights. Some of the lights were bar shaped and some were circular. It had four directional buttons as well as a start and a select button. Finally, the bottom 3rd of the game was an enormous vent.  Have a look at this picture from Electronic Plastic (http://www.electronicplastic.com/game/?company=&id=625), to see for yourself.

I have created a port of Split Second to the NES. I tried to keep the same look and feel as with the original game. I also tried to replicate the game play and sounds as best as I could. Once completed, I submitted this game to NESDev.com as part of the 2018 NESDev Competition.

Here were my technical goals/achievements for this project:
1. Learn 6502 assembly language.
2. Learn to use NESASM compiler.
3. Learn to use an NROM 128 mapper to keep things simple.
4. Use only background tiles (no sprites anywhere in the game).
5. Create simple light weight sound engine.

One thing I would like to call out is that I do not wish to plagiarize anything from the original hand-held game. I tried to call this out explicitly by citing the original work from Parker Brothers on the title screen. I wrote my own code and produced my own graphics. I’d like to think of this project as a tribute to Split Second.

How does one play? See the original manual (https://www.manualslib.com/manual/1216146/Parker-Brothers-Split-Second.html?page=2#manual) for details. But it’s pretty straight forward. There are 8 distinct games. You select a game by using the select button and you start playing a game by using the start button. In some of the games you move a ball around the screen. In some of the games you move a bars around the screen. The object of each game is to complete the course as fast as you can. If you’re playing by yourself you can do time trials to see how fast you can complete each game. If you’re playing with multiple people you can take turns to see who is the fastest! I would recommend playing with the sound on as the scoring feedback system was originally meant to be heard. For example, there are different sounds for beating your previous score versus failing to beat your previous score etc. 

Here are the names of the games:
1. Mad Maze (Visible)
2. Mad Maze (Preview)
3. Mad Maze (Invisible)
4. Space Attack (Beginner)
5. Space Attack (Pro)
6. Auto Cross
7. Stomp
8. Speedball

Hope you have a chance to play. 

*Acknowledgements:*

Thanks to all the members of the NESDev and Nintendo Age communities for helping me get started.
Thanks to Parker Brothers for the original hand-held Split Second game.
Thanks to BunnyBoy for writing the original NES "Nerdy Nights" tutorials.
Thanks to Damian Yerrick for sharing his NTSC/PAL/Dendy system detection code.
Thanks to KHAN Games and SoleGooseProductions for their amazing NES Assembly Line Podcast, which helped encourage me to complete the game.
