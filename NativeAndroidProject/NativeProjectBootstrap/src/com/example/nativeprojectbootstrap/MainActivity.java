package com.example.nativeprojectbootstrap;

import android.support.v7.app.ActionBarActivity;
import android.util.Log;
import android.support.v7.app.ActionBar;
import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.os.Build;

public class MainActivity extends ActionBarActivity {

	public void onBackToUnityClicked(View view)
	{
		Log.i("MainActivity", "Returning to Unity..");
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		int id = getResources().getIdentifier("test_view", "layout", getPackageName());
		setContentView(id);
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {

		// Inflate the menu; this adds items to the action bar if it is present.
		int id = getResources().getIdentifier("main", "menu", getPackageName());
		getMenuInflater().inflate(id, menu);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		// Handle action bar item clicks here. The action bar will
		// automatically handle clicks on the Home/Up button, so long
		// as you specify a parent activity in AndroidManifest.xml.
		int id = item.getItemId();
		int action_settings = getResources().getIdentifier("action_settings", "id", getPackageName());
		if (id == action_settings) {
			return true;
		}
		return super.onOptionsItemSelected(item);
	}
}
