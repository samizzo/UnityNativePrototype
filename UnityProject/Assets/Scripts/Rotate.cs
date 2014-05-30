using UnityEngine;
using System.Collections;

public class Rotate : MonoBehaviour
{
	void Update()
	{
		transform.rotation = Quaternion.identity;
		transform.Rotate(0.0f, 0.0f, Mathf.Repeat(Time.realtimeSinceStartup, 360.0f) * 100.0f);
	}
}
