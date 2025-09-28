using UnityEngine;
using UnityEngine.Events;

public class EnemyBehaviour : MonoBehaviour
{
	// ---------- COMPONENTES ----------
	[SerializeField] EnemyManager _enemyManager;

	// Referencia ao componente de animacao do inimigo
	[SerializeField] CharacterAnimation _enemyAnimation;

	// Referencia ao componente de movimento do inimigo
	[SerializeField] CharacterMovement _enemyMovement;

	// ---------- VARIAVEIS DE JOGO ----------

	// Referencia ao jogador que sera perseguido
	public PlayerManager Player;

	// Distancia maxima para comecar a perseguir o jogador
	[SerializeField] float _chaseThreshold = 3.5f;

	// Distancia maxima para atacar o jogador
	[SerializeField] float _attackThreshold = 2f;

	// Quantidade de dano causado ao jogador
	[SerializeField] float _attackDamage = 10f;

	// Distancia atual para o jogador (calculada a cada frame)
	[SerializeField] float _playerDistance;

	// Flag para controlar animacao de caminhada
	bool _isWalking = false;

	// ---------- METODOS DO CICLO DE VIDA ----------

	// Chamado quando o GameObject e inicializado
	private void Start()
	{
		_enemyManager = GetComponent<EnemyManager>();
		_enemyAnimation = _enemyManager.CharacterAnimation;
		_enemyMovement = _enemyManager.CharacterMovement;

		_attackDamage = _enemyManager.Dano;
		_chaseThreshold = _enemyManager.DistanciaParaSeguir;
		_attackThreshold = _enemyManager.DistanciaParaAtacar;
		// Procura o jogador na cena usando a tag "Player" e guarda a referencia
		Player = GameObject.FindWithTag("Player").GetComponent<PlayerManager>();

		_playerDistance = _chaseThreshold;
	}

	// Chamado a cada frame, usado para atualizacao de animacoes e calculo de distancia
	void Update()
	{
		// Calcula a distancia entre o jogador e o inimigo
		_playerDistance = Vector3.Distance(Player.GetPlayerTransform().position, transform.position);

		// Atualiza a animacao de movimento do inimigo
		_enemyAnimation.SetMovementAnimation(_isWalking);
	}

	// Chamado a cada frame de fisica, usado para movimentacao do inimigo
	void FixedUpdate()
	{
		// Verifica se o jogador esta dentro do raio de perseguir
		if (_playerDistance < _chaseThreshold)
		{
			// Calcula a direcao para se mover em direcao ao jogador
			float playerDirection = Mathf.Sign(Player.GetPlayerTransform().position.x - transform.position.x);

			// Move o inimigo na direcao do jogador
			_enemyMovement.Move(_enemyMovement.GetMoveSpeed() * playerDirection * Time.fixedDeltaTime, false);

			// Marca que o inimigo esta andando para animacao
			_isWalking = true;

			// Se o jogador estiver dentro do raio de ataque, aplica dano
			if (_playerDistance < _attackThreshold)
			{
				Player.OnTakingDamage?.Invoke(_attackDamage * Time.fixedDeltaTime);
			}
		}
		else
		{
			// Para o inimigo se o jogador estiver fora do raio de perseguir
			_enemyMovement.Move(0, false);
			_isWalking = false;
		}
	}

	// Desenha gizmos na cena para visualizar os raios de chase e ataque
	void OnDrawGizmos()
	{
		Gizmos.color = Color.yellow;
		Gizmos.DrawWireSphere(transform.position, _chaseThreshold);

		Gizmos.color = Color.red;
		Gizmos.DrawWireSphere(transform.position, _attackThreshold);
	}
}

