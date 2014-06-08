using UnityEngine;
using System.Runtime.InteropServices;

public class UnityNativeInterface
{
#if UNITY_EDITOR
	public static void SwitchToNative()
	{
		Debug.Log("Only implemented on iOS and Android!");
	}
#elif UNITY_IOS
	[DllImport ("__Internal")]
	public static extern void SwitchToNative();
#elif UNITY_ANDROID
    public static void SwitchToNative()
    {
        AndroidJavaClass jc = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
        AndroidJavaObject jo = jc.GetStatic<AndroidJavaObject>("currentActivity");
        jo.Call("switchToNative");
    }
#endif
}
