![TFrameStand](media/frame_stand_xhdpi.png)
![TFormStand](media/form_stand_xhdpi.png)
#TFrameStand and TFormStand components (FMX)
Easily use TFrame or TForm descendants in your FireMonkey (FMX) applications to gain visual consistency though the whole user experience and easily add modern looking elements like effects and transitions.

_All code and demos tested on Delphi XE8 and Delphi 10.3 Rio._

##Installation - GetIt!
**TFrameStand and TFormStand are [available on GetIt](https://blog.andreamagni.eu/2017/05/tframestand-v-1-3-available-on-github-and-getit/) (Embarcadero's Package Manager)**

_Current version on GetIt: 1.4 (TFrameStand only!)_

##Installation - Manual
1. Open “packages\FrameStand_10_3.groupproj”
2. Build both contained packages
2. Install “dclFrameStandPackage_10_3_260.bpl” design time package
3. Add “source\” library path for Delphi (do this for each platform you need to support)

_Installing manually you get the latest updates (beware! :-) )_

##Main functionalities
* Use any TFrame/TForm and show it through TFrame/TFormStand to add animations, effects and stands (a common visual layer between the TFrame/TForm and its Parent)
* Share CommonActions through different UI combinations
* Responsive frame substitution
* Take advantage of design time style preview and Fire UI technology through TFormStand

##Get started
* Have a look at [my blog posts about TFrameStand](https://blog.andreamagni.eu/tag/tframestand/)
* [My CodeRage X session (50 min video covering all the basic functionalities)](https://www.youtube.com/watch?v=Z6_ZvnCmFCw)

##Demo projects
* **wait**: a wait splashscreen with running animation and opacity. Can be show on the top of a whole form or a single FMX control. Runs a task on a background thread and keeps UI responsive.
* **lightbox**: achieves the popular lightbox effect to show different kind of content (pictures, text, data) using a consistent UI. Also provides an example of CommonActions use (the Close button) and provides fade-in animation of content
* **material_button**: a simple example to overlay a button on the form or any other control, with sliding animations.
* **ViewAndDialogs**: some Material Design-like transition to show a view (employee's details) and a dialog (rate a picture).
* **PictureWall**: show pictures in a TFlowLayout with a fading in transition
* **ButtonSet**: mimics Android's Camera toolbuttons laying over your content.
* **EditHelper**: adds easy to customize buttons or controls to any TEdit.
* **BottomSheet**: implementation of a bottom sheet UI element with TFrameStand
* **ResponsiveProject**: implementation of responsive application with FMX and TFrameStand

# Contributions
This is an open source project, so obviously every contribution/help/suggestion will be very appreciated.

[Andrea Magni](http://www.andreamagni.eu)
