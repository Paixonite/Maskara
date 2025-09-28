using UnityEngine;

public class PlayerController : MonoBehaviour
{
	// ---------- COMPONENTES ----------

	// Refer�ncia ao PlayerManager, que gerencia informa��es gerais do jogador (vida, transform etc.)
	[SerializeField] PlayerManager _playerManager;

	// Refer�ncia ao componente CharacterMovement, que cont�m a l�gica de movimento do personagem
	[SerializeField] CharacterMovement _playerMovement;

	// Refer�ncia ao componente CharacterCombat, que cont�m a l�gica de combate (ataques, cooldowns etc.)
	[SerializeField] CharacterCombat _playerCombat;

	// Refer�ncia ao componente CharacterAnimation, que controla as anima��es do personagem
	[SerializeField] CharacterAnimation _playerAnimation;


	// ---------- VARI�VEIS DE CONTROLE ----------

	// Entrada de movimento horizontal do jogador (-1 esquerda, 0 parado, +1 direita)
	float _movementInput;

	// Flag para indicar se o jogador apertou o bot�o de pulo neste frame
	bool _jump = false;

	// Controla o tempo do pr�ximo ataque (usado para aplicar cooldown entre ataques)
	float _nextAttackTime = 0f;


	// ---------- M�TODOS DO CICLO DE VIDA UNITY ----------

	private void Start()
	{
		_playerManager = GetComponent<PlayerManager>();
		_playerMovement = _playerManager.CharacterMovement;
		_playerAnimation = _playerManager.CharacterAnimation;
		_playerCombat = _playerManager.CharacterCombat;
	}

	// Chamado a cada frame (independente da f�sica). Ideal para capturar inputs do jogador.
	void Update()
	{
		// Captura a entrada horizontal do jogador (teclas A/D, setas ou controle)
		_movementInput = Input.GetAxis("Horizontal");

		// Atualiza as anima��es de movimento de acordo com a entrada
		_playerAnimation.SetMovementAnimation(_movementInput);

		// Verifica se o jogador apertou o bot�o de pulo
		if (Input.GetButtonDown("Jump"))
		{
			_jump = true; // marca que o jogador quer pular
			_playerAnimation.SetJumpingAnimation(_jump); // atualiza anima��o de pulo
		}

		// Verifica se j� passou tempo suficiente para o pr�ximo ataque
		if (Time.time >= _nextAttackTime)
		{
			// Se o jogador apertou o bot�o de ataque
			if (Input.GetButtonDown("Attack"))
			{
				// Executa o ataque atrav�s do componente de combate
				_playerCombat.Attack();

				// Define o pr�ximo tempo em que ser� poss�vel atacar novamente
				_nextAttackTime = Time.time + 1f / _playerCombat.GetAttackRate();
			}
		}
	}

	// Chamado em intervalos fixos, sincronizado com o motor de f�sica da Unity.
	// Ideal para aplicar movimento ou for�as no Rigidbody.
	void FixedUpdate()
	{
		// Aplica o movimento no personagem, passando a velocidade baseada no input
		// Multiplica pela velocidade de movimento configurada e pelo deltaTime fixo
		_playerMovement.Move(_playerMovement.GetMoveSpeed() * _movementInput * Time.fixedDeltaTime, _jump);

		// Reseta o pulo para evitar m�ltiplos pulos sem apertar o bot�o novamente
		_jump = false;
	}
}

