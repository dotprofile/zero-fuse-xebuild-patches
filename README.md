# zero-fuse-xebuild-patches
Additional patches for Zero Fuse Xbox 360 consoles, the aim is to port more dash versions to Zero Fuse consoles

Right now: 

6717

7258

9199

13604

15574 ( dashlaunch plugins cause E79 ATM, working on a fix)




I want to make it clear that I am just some literal who with a lot of persistence. All I have done here is line up the vfuse/flag fixer/hvFixKeys patches for the most part. 

I got a LOT of info from the following, none of this would have been possible without these nice people/repos:

https://github.com/XboxChef/RGLoader

https://github.com/GoobyCorp/Xbox-360-Crypto/

https://github.com/g91/XBLS


Instructions for use: Download the zip file from https://github.com/dotprofile/zero-fuse-xebuild-patches/releases and extract, copy the XeBuild folder into your J-Runner With Extras folder, and restart J-Runner


Note: For 7258 it had issues with my SSD. A stock HDD was fine, and also a newly formatted SSD also worked. Not sure what is up with that just FYI. I will chalk it up to beta things. 



As long as you have a copy of SB_priv.bin in xeBuild\common, the devgl/zero fuse options will be active in J-Runner and will allow you to build an image. 

Everything should function as it does on a regular hacked console. I really didn't change a whole lot, mostly additions of a few things to align with the flag fixer/vfuse/hvfixkeys of 17559. 

I don't know much about zero fuse consoles other than the BB Jasper I have, and unsure if these will work on those as the patches are only for Jasper/Trinity/Corona (not sure if it will work on Trinity/Corona, I just stitched in my patches over the 17559 HV/Kernel patches).

<img width="327" height="256" alt="{61A707CB-3149-40B4-B095-D651BAF637AA}" src="https://github.com/user-attachments/assets/96d9d8f1-2ffd-45e4-a33d-72c3e811e6ac" />



6717

<img width="922" height="521" alt="{43B3D7CF-8379-4C0B-8147-98B7E832583D}" src="https://github.com/user-attachments/assets/1646500a-3b68-439c-bd1d-441ffdc94ece" />

<img width="506" height="255" alt="{34914782-4918-4FC7-9569-A84CE25EF6CE}" src="https://github.com/user-attachments/assets/fa62489d-d5fb-4f55-ae12-d8cfba9ba0c0" />




9199:

<img width="927" height="521" alt="{4709B50C-0174-4F80-84CB-900AE1751664}" src="https://github.com/user-attachments/assets/bec0528e-f773-4cf5-98f1-e649bc748ac6" />

<img width="480" height="274" alt="{1D401503-BB80-4745-B0BF-64DD537123CD}" src="https://github.com/user-attachments/assets/a4b9b5e6-a413-4b26-bb92-c1be9b32e87b" />
