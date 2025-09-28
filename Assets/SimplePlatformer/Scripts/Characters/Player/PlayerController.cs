using UnityEngine;

public class PlayerController : MonoBehaviour
{
	// ---------- COMPONENTES ----------

	// Referência ao PlayerManager, que gerencia informações gerais do jogador (vida, transform etc.)
	[SerializeField] PlayerManager _playerManager;

	// Referência ao componente CharacterMovement, que contém a lógica de movimento do personagem
	[SerializeField] CharacterMovement _playerMovement;

	// Referência ao componente CharacterCombat, que contém a lógica de combate (ataques, cooldowns etc.)
	[SerializeField] CharacterCombat _playerCombat;

	// Referência ao componente CharacterAnimation, que controla as animações do personagem
	[SerializeField] CharacterAnimation _playerAnimation;


	// ---------- VARIÁVEIS DE CONTROLE ----------

	// Entrada de movimento horizontal do jogador (-1 esquerda, 0 parado, +1 direita)
	float _movementInput;

	// Flag para indicar se o jogador apertou o botão de pulo neste frame
	bool _jump = false;

	// Controla o tempo do próximo ataque (usado para aplicar cooldown entre ataques)
	float _nextAttackTime = 0f;


	// ---------- MÉTODOS DO CICLO DE VIDA UNITY ----------

	private void Start()
	{
		_playerManager = GetComponent<PlayerManager>();
		_playerMovement = _playerManager.CharacterMovement;
		_playerAnimation = _playerManager.CharacterAnimation;
		_playerCombat = _playerManager.CharacterCombat;
	}

	// Chamado a cada frame (independente da física). Ideal para capturar inputs do jogador.
	void Update()
	{
		// Captura a entrada horizontal do jogador (teclas A/D, setas ou controle)
		_movementInput = Input.GetAxis("Horizontal");

		// Atualiza as animações de movimento de acordo com a entrada
		_playerAnimation.SetMovementAnimation(_movementInput);

		// Verifica se o jogador apertou o botão de pulo
		if (Input.GetButtonDown("Jump"))
		{
			_jump = true; // marca que o jogador quer pular
			_playerAnimation.SetJumpingAnimation(_jump); // atualiza animação de pulo
		}

		// Verifica se já passou tempo suficiente para o próximo ataque
		if (Time.time >= _nextAttackTime)
		{
			// Se o jogador apertou o botão de ataque
			if (Input.GetButtonDown("Attack"))
			{
				// Executa o ataque através do componente de combate
				_playerCombat.Attack();

				// Define o próximo tempo em que será possível atacar novamente
				_nextAttackTime = Time.time + 1f / _playerCombat.GetAttackRate();
			}
		}
	}

	// Chamado em intervalos fixos, sincronizado com o motor de física da Unity.
	// Ideal para aplicar movimento ou forças no Rigidbody.
	void FixedUpdate()
	{
		// Aplica o movimento no personagem, passando a velocidade baseada no input
		// Multiplica pela velocidade de movimento configurada e pelo deltaTime fixo
		_playerMovement.Move(_playerMovement.GetMoveSpeed() * _movementInput * Time.fixedDeltaTime, _jump);

		// Reseta o pulo para evitar múltiplos pulos sem apertar o botão novamente
		_jump = false;
	}
}

