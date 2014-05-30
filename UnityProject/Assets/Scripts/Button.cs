using UnityEngine;
using System.Collections;

public class Button : MonoBehaviour
{
	void OnGUI()
	{
		GUIStyle style = new GUIStyle();
		style.alignment = TextAnchor.MiddleCenter;
		GUI.Label(new Rect(0, Screen.height * 0.1f, Screen.width, 20.0f), "This is Unity!", style);
		if (GUI.Button(new Rect(Screen.width * 0.25f, Screen.height * 0.2f, Screen.width * 0.5f, 50), "Switch to native.."))
		{
			Debug.Log("Switching to native..");
		}
	}
}
