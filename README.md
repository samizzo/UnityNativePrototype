# Overview

This repository demonstrates how to integrate Unity with UIKit and the native Android UI. It consists of three projects:

* UnityProject - a sample Unity project that renders some text and a button, and allows switching to the native view
* NativeProject - an Xcode project that has two subprojects:
   * NativeProjectLib - a static iOS library that provides a sample native UI with a navigation controller and a button to switch back to Unity
   * NativeProjectBootstrap - an iOS app that links against the static library in order to allow iterating on the native UI
* NativeAndroidProject - two Android projects:
   * NativeProjectLib - an Android library that provides a sample native UI with a button to switch back to Unity
   * NativeProjectBootstrap - an Android app that links against the Android library in order to allow iterating on the native UI

## NativeProject (iOS)

### NativeProjectLib

This is a static iOS library. It has a storyboard with a sample UI. The NativeInterface.h header file has an interface class for allocating the UI and accessing the root UIViewController and the UIStoryboard objects.

The notification centre is used to signal when to switch back to Unity; however any other mechanism could also be used (for example, a delegate or even exposing the button and allowing the client to hook up the action itself). The library currently sends the message "SwitchToUnityRequested".

### NativeProjectBootstrap

This is an iOS executable that provides a wrapper around the static library. This is not used in Unity, but instead is used to allow iterating on the native UI without requiring integration into Unity. The AppDelegate instantiates NativeInterface and sets its rootViewController to the NativeInterface ViewController, and also registers for the "SwitchToUnityRequested" notification message.

It is important to note that the -ObjC linker flag must be used to ensure that all Objective-C classes and categories are loaded when linking. Otherwise the linker may optimise out classes that are not referenced, causing runtime errors.

It may also be necessary to use the -force_load or -all_load flags to work around a linker bug when the static library contains only categories and no classes. See https://developer.apple.com/library/mac/qa/qa1490/_index.html for details.

## NativeAndroidProject (Android)

### NativeProjectLib

This is an Android library. It has a single TableLayout with a button to switch back to Unity. It also has a custom native activity called CustomNativeActivity that derives from UnityPlayerNativeActivity in order to provide the interface to switch between native UI and Unity. This is only used by Unity and not by the bootstrap application.

### NativeProjectBootstrap

This is an Android executable that provides a wrapper around the library. This is not used in Unity, but instead is used to allow iterating on the native UI without requiring integration into Unity.

## Eclipse setup

1. Import the NativeProjectLib, NativeProjectBootstrap, and appcompat projects into Eclipse (note: replace appcompat with the one that comes with your SDK if necessary).
2. Ensure that the path to Unity's classes.jar is correct in NativeProjectLib (right-click NativeProjectLib->Properties->Java Build Path->Libraries).
3. You should be able to run NativeProjectBootstrap.

## UnityProject

This is a sample Unity project that uses the libraries. In the project there is an iOS plugin that interfaces to the static library located in Assets/Plugins/iOS. There is an Android plugin to interface with Android located in Assets/Plugins/Android.

### iOS integration

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

### Android integration

The Android plugin contains an AndroidManifest.xml that specifies what activity to start when the application boots. It also contains all resources from the library, and a jar file containing the code from the library.

The CustomNativeActivity in the jar file implements the interface that the C# code can call to.

## iOS - Workflow

The person implementing the native UI can work in the NativeProject Xcode project. They can iterate on the native UI and build, run, and test within Xcode without touching Unity.

The person implementing the Unity part can work in Unity solely on the Unity part.

At some point updates will need to be integrated. To integrate, the following files from the static library should be copied into the Unity iOS plugin directory:

* libNativeProjectLib.a
* NativeInterface.h
* Storyboard.storyboard (or any additional storyboard, XIB, etc files)

Then the Unity project can be built out to Xcode as detailed above.

## Android - Workflow

The person implementing the native UI can work in the NativeAndroidProject projects. They can iterate on the native UI and build, run, and test within Xcode without touching Unity.

The person implementing the Unity part can work in Unity solely on the Unity part.

At some point updates will need to be integrated. To integrate, the following files from the Android library should be copied into the Unity Android plugin directory:

* nativeprojectlib.jar from NativeProjectLib/bin into the bin directory
* The entire NativeProjectLib/res contents directory into the res directory

## iOS - Building from Unity

To build the entire project out for running on a device:

1. Start Unity.
2. Load the Unity project.
3. Bring up the Build Settings window (File->Build Settings).
4. Switch platform to iOS
5. Hit Build. Unity will ask where you would like to generate the project. Give it a folder name (it can be anything - let's assume "xcode").
6. Once it has finished building, go into that folder and you should see an Xcode project. Load the project.
7. Add the storyboard file Storyboard.storyboard to the project (it is in xcode/Libraries).
8. Add the -ObjC flag to "Other linker flags" in Build Settings->Linking.
9. Run the project.

## iOS - Building for simulator

1. In Unity, go to Edit->Project Settings->Player.
2. Find the SDK Version setting and set it to "Simulator SDK".
3. Rebuild the NativeProjectLib static library for simulator (instead of device).
4. Copy the static library (libNativeProjectLib.a) into the Plugins/iOS directory in Unity.
5. Build from Unity as detailed above.
6. Before building or running in Xcode, make the following changes:
   - In RegisterMonoModules.cpp, the definition of mono_dl_register_symbol should be moved out of the #if !(TARGET_IPHONE_SIMULATOR) block
   - In RegisterMonoModules.cpp, the call to mono_dl_register_symbol where it registers the SwitchToNative function should be moved out of the #if !(TARGET_IPHONE_SIMULATOR) block
7. Now you can build/run from Xcode.

## Android - Building from Unity

To build the entire project out for running on a device:

1. Start Unity.
2. Load the Unity project.
3. Bring up the Build Settings window (File->Build Settings).
4. Switch platform to Android
5. Hit Build or Build and Run.

