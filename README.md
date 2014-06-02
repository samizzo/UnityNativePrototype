Overview
--------



todo:
- find way to automatically add storyboard file to xcode project
- find way to automatically add -ObjC to other linker flags

when building unity app:
- after building out to xcode, in xcode add the storyboard file to the project (it is copied into the 'libraries' directory but isn't added to the project)
- to run unity app in simulator, in RegisterMonoModules.cpp:
   - move definition of mono_dl_register_symbol function out of #if !(TARGET_IPHONE_SIMULATOR) and the call to it that registers _switchToNative also out of the #if block
   - if you don't do this you won't be able to test the switching in the simulator (it will work fine on the device though)
- if building for simulator, you need to build a version of the native interface library that is built for the simulator. if you want to build for the device you need to replace the lib with a verisno of the native interface built for the device. you can't have both in the unity project.