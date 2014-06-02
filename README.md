# Overview

This repository demonstrates how to integrate Unity with UIKit. It consists of two projects:

* UnityProject - a sample Unity project that renders some text and a button, and allows switching to the native view
* NativeProject - an Xcode project that has two subprojects:
   * NativeProjectLib - a static iOS library that provides a sample native UI with a navigation controller and a button to switch back to Unity
   * NativeProjectBootstrap - an iOS app that links against the static library in order to allow iterating on the native UI

## NativeProject

### NativeProjectLib

This is a static iOS library. It has a storyboard with a sample UI. The NativeInterface.h header file has an interface class for allocating the UI and accessing the root UIViewController and the UIStoryboard objects.

The notification centre is used to signal when to switch back to Unity; however any other mechanism could also be used (for example, a delegate or even exposing the button and allowing the client to hook up the action itself). The library currently sends the message "SwitchToUnityRequested".

### NativeProjectBootstrap

This is an iOS executable that provides a wrapper around the static library. This is not used in Unuity, but using the bootstrap project means that the UI can be iterated on without requiring integration into Unity. The AppDelegate instantiates NativeInterface and sets its rootViewController to the NativeInterface ViewController, and also registers for the "SwitchToUnityRequested" notification message.

It is important to note that the -ObjC linker flag must be used to ensure that all Objective-C classes and categories are loaded when linking. Otherwise the linker may optimise out classes that are not referenced, causing runtime errors.

It may also be necessary to use the -force_load or -all_load flags to work around a linker bug when the static library contains only categories and no classes. See https://developer.apple.com/library/mac/qa/qa1490/_index.html for details.

## UnityProject

This is a sample Unity project that uses the static library. In the project there is an iOS plugin (located in Assets/Plugins/iOS) that interfaces to the static library.

The static library is copied into the plugins directory, along with the public header (NativeInterface.h) and the Storyboard file. The storyboard or any XIB/NIB files *MUST* be placed in the Unity folder, because they are *NOT* built into the static library.

There is also a file called UnityNativeInterface.m. This file extends and overrides the default Unity AppController class in order to instantiate the NativeInterface from the static library, and provide the interface between Unity and the native code. Two methods are provided:

   * switchToUnity
   * switchToNative

switchToUnity is attached to the notification centre "SwitchToUnityRequested" message. switchToNative is exposed to Unity via the global SwitchToNative function (the C# function is declared in UnityNativeInterface.cs).

When building from Unity for iOS, after the Xcode project is generated and loaded, the following manual steps must be performed in Xcode:

* Add the storyboard file to the project (it is copied by Unity into the Xcode project's "Libraries" directory but isn't added to the project)
* Add the -ObjC flag to "Other linker flags" (and also possibly -force_load or -load_all as mentioned above)

The project can then be built and run on a device.

Note that if you wish to run the Unity project in the simulator, a couple of things need to be done:

* In Unity's player settings you should select "Simulator SDK" as the SDK version, instead of "Device SDK"
* The NativeProjectLib static library should also be rebuilt for the simulator (the checked in version is built for the device)
* In RegisterMonoModules.cpp, the definition of mono_dl_register_symbol should be moved out of the #if !(TARGET_IPHONE_SIMULATOR) block
* The call to mono_dl_register_symbol where it registers the SwitchToNative function should be moved out of the #if !(TARGET_IPHONE_SIMULATOR) block

