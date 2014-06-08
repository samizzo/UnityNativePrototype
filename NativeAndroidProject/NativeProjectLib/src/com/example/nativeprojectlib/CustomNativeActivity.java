package com.example.nativeprojectlib;

import com.example.nativeprojectlib.R;
import com.unity3d.player.*;

import android.util.Log;
import android.app.NativeActivity;
import android.content.res.Configuration;
import android.graphics.PixelFormat;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;

public class CustomNativeActivity extends UnityPlayerNativeActivity
{
	public void onBackToUnityClicked(View view)
	{
		Log.i("UnityPlayerNativeActivity", "Switching to Unity from Android UI..");
		runOnUiThread(new Runnable()
		{
			@Override public void run()
			{
				switchToUnityImp();
			}
		});
	}

	protected void switchToNative()
	{
		Log.i("UnityPlayerNativeActivity", "Switching to Android UI from Unity..");
		runOnUiThread(new Runnable()
		{
			@Override public void run()
			{
				switchToNativeImp();
			}
		});
	}

	private void switchToNativeImp()
	{
		mUnityPlayer.pause();
		int id = getResources().getIdentifier("test_view", "layout", getPackageName());
		setContentView(id); // R.layout.test_view
	}
	
	private void switchToUnityImp()
	{
		mUnityPlayer.resume();
		setContentView(mUnityPlayer);
	}
}
