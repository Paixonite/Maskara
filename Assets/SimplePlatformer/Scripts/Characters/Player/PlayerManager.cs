using UnityEngine;
using UnityEngine.Events;

[RequireComponent(typeof(PlayerController))]
[RequireComponent(typeof(CharacterCombat))]
public class PlayerManager : CharacterManager
{
	[Header("Componentes do Personagem")]
	[SerializeField] Transform _playerTransform;
	public Transform GetPlayerTransform() { return _playerTransform; }

	public PlayerController PlayerController;
	//public CharacterCombat PlayerCombat;

	protected override void Awake()
	{
		base.Awake();
		_playerTransform = transform;
		PlayerController = GetComponent<PlayerController>();
		CharacterCombat = GetComponent<CharacterCombat>();
	}
}
