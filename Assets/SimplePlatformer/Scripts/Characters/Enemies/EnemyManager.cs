using UnityEngine;
using UnityEngine.Events;

[RequireComponent(typeof(EnemyBehaviour))]
public class EnemyManager : CharacterManager
{
	public EnemyBehaviour EnemyBehaviour;
	protected override void Awake()
	{
		base.Awake();
		_characterHealth.OnDying.AddListener(OnDying);
		EnemyBehaviour = GetComponent<EnemyBehaviour>();
	}

	public void OnDying()
	{
		Destroy(gameObject);
	}
}
