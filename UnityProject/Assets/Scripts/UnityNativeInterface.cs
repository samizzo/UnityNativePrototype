using UnityEngine;
using System.Runtime.InteropServices;

public class UnityNativeInterface
{
#if UNITY_IOS && !UNITY_EDITOR
	[DllImport ("__Internal")]
	public static extern void SwitchToNative();
#else
	public static void SwitchToNative()
	{
		Debug.Log("Unimplemented in non-IOS platforms");
	}
#endif
}
