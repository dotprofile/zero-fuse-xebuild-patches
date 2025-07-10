# zero-fuse-xebuild-patches
Additional patches for Zero Fuse Xbox 360 consoles, the aim is to port more dash versions to Zero Fuse consoles

Right now: 

6717

Soon:

9199


I want to make it clear that I am just some literal who with a lot of persistence. All I have done here is line up the vfuse/flag fixer/hvFixKeys patches for the most part. 

I got a LOT of info from the following, none of this would have been possible without these nice people/repos:

https://github.com/XboxChef/RGLoader

https://github.com/GoobyCorp/Xbox-360-Crypto/

https://github.com/g91/XBLS



Instructions for use for 6717: 

Copy all the bin files from     xeBuild/6717/bin

Place in: J-Runner-with-Extras\xeBuild\6717\bin

Copy _devgl.ini to: J-Runner-with-Extras\xeBuild\6717

Instructions for use for 9199:

Copy all the bin files from     xeBuild/9199/bin

Place in: J-Runner-with-Extras\xeBuild\9199\bin

Copy _devgl.ini to: J-Runner-with-Extras\xeBuild\9199


I noticed that building with Jrunner causes you to have a "fake" CPU key in dashlaunch/simple 360 nand flasher. This is just visual, I will look into Jrunner, perhaps the zero fuse button isn't doing anything for those versions and there needs to be tweaks to the app. I will look into that. 

As long as you have a copy of SB_priv.bin in xeBuild\common, the devgl/zero fuse options will be active in J-Runner and will allow you to build an image. 


I don't know much about zero fuse consoles other than the BB Jasper I have, and unsure if these will work on those as the patches are only for Jasper/Trinity/Corona (not sure if it will work on Trinity/Corona, I just stitched in my patches over the 17559 HV/Kernel patches).
