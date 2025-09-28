using UnityEngine;
using UnityEngine.Events;

public class CharacterCombat : MonoBehaviour
{
	// ---------- COMPONENTES ----------

	[SerializeField] CharacterManager _characterManager;

	// Referencia ao componente de animacao do personagem
	[SerializeField] CharacterAnimation _characterAnimation;

	// Objeto visual que representa o efeito de ataque
	[SerializeField] GameObject _attackEffect;


	// ---------- VARIAVEIS DE ATAQUE ----------

	// Taxa de ataque (ataques por segundo)
	[SerializeField] float _attackRate = 2f;
	public float GetAttackRate() { return _attackRate; }

	// Ponto de origem do ataque (posicao no mundo)
	[SerializeField] Transform _attackPoint;

	// Alcance do ataque (raio do circulo de dano)
	[SerializeField] float _attackRange = .75f;

	// Quantidade de dano do ataque
	[SerializeField] float _attackDamage = 20f;

	// LayerMask para identificar inimigos que podem ser atingidos
	[SerializeField] LayerMask _enemyLayerMask;

	public UnityEvent OnAttack;
	// ---------- METODOS ----------
	private void Awake()
	{
		_enemyLayerMask = LayerMask.GetMask("Enemy");
		_characterManager = GetComponent<CharacterManager>();
		_characterAnimation = _characterManager.CharacterAnimation;
		_attackDamage = _characterManager.Dano;
		_attackRate = _characterManager.HitsPorSegundo;
		_attackRange = _characterManager.RaioDeAtaque;
	}
	// Executa o ataque
	public void Attack()
	{
		// Dispara animacao de ataque
		_characterAnimation.SetAttackAnimation();

		OnAttack?.Invoke();

		// Ativa efeito visual, se houver
		if (_attackEffect != null)
		{
			EnableAttackEffect();
		}

		// Detecta inimigos dentro do alcance do ataque
		Collider2D[] hitEnemies = Physics2D.OverlapCircleAll(_attackPoint.position, _attackRange, _enemyLayerMask);

		// Aplica dano a cada inimigo detectado
		foreach (Collider2D hitEnemy in hitEnemies)
		{
			hitEnemy.gameObject.GetComponent<EnemyManager>()?.OnTakingDamage?.Invoke(_attackDamage);
		}
	}

	// Ativa o efeito visual do ataque
	public void EnableAttackEffect()
	{
		_attackEffect.SetActive(true);
	}


	// Desenha gizmo no editor para mostrar o alcance do ataque
	private void OnDrawGizmos()
	{
		// Define cor do gizmo (usar apenas cores padrao RGB para evitar Unicode)
		Gizmos.color = new Color(1f, 0.55f, 0f); // equivalente a "dark orange"

		// Desenha o circulo representando o alcance do ataque
		if (_attackPoint != null)
		{
			Gizmos.DrawWireSphere(_attackPoint.position, _attackRange);
		}
	}
}

