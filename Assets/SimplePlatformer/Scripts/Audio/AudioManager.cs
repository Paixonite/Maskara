using UnityEngine;
using UnityEngine.Audio;
using System;

[RequireComponent(typeof(AudioListener))]
public class AudioManager : MonoBehaviour
{
    public Sound[] Sounds;

	private void Awake()
	{
		foreach (Sound sound in Sounds)
		{
			sound.Source = gameObject.AddComponent<AudioSource>();
			sound.Source.clip = sound.Clip;
			sound.Source.volume = sound.Volume;
			sound.Source.pitch = sound.Pitch;
			sound.Source.loop = sound.Loop;
		}
	}

	public void PlayAudio(string name)
	{
		Sound s = Array.Find(Sounds, sound => sound.Name == name);
		s.Source.Play();
	}

	public void StopAudio(string name)
	{
		Sound s = Array.Find(Sounds, sound => sound.Name == name);
		s.Source.Stop();
	}
}
