using UnityEngine;
using System.Collections;

public class Rotate : MonoBehaviour
{
	private float m_timer = 0.0f;
	void Update()
	{
		transform.rotation = Quaternion.identity;
		transform.Rotate(0.0f, 0.0f, Mathf.Repeat(m_timer, 360.0f) * 100.0f);
		m_timer += Time.deltaTime;
	}
}
