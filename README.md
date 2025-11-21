Electrical Plate SCAD
=====================

An OpenSCAD model of a US electrical faceplate, with additional Aqara smart device support.

Overview
--------

I wanted to add smart swtiches to my home, but as a rental I didn't want to make any permenant changes, nor do I have a neutral wire. My solution
was to bypass the normal switch and mount the buttons to the faceplate. To do so I needed to replace all my faceplates with plates that included
blanks--which can be found, but are not easily found and as each faceplate is unique, add up in cost quite quickly.

Given the variety of plates I would need, I modeled it in OpenSCAD so that I could print variations on demand.

The original plan was to simply stick the smart button on top of the blank in the faceplate, but I found a very well-designed wall mount for my
Aqara buttons from Volan on Printables (https://www.printables.com/model/299928-aqara-mounts-for-various-sensors-v13) and decided to add that
feature to my model.

Printing
--------

Anything but the Aqara mount will print perfectly face-down. If you want to print an Aqara mount, or for some reason don't want to print face-down,
you can also generate a support enforcer specific to your layout. The enforcer has horizontal bands so that bridges are much shorter, so make sure
those bands are oriented perpendicular to your first full layer's orientation.

Any support material (including the print material) should work fine, but I have also had success printing with a non-compatible material like PETG
for PLA (or vis versa).
