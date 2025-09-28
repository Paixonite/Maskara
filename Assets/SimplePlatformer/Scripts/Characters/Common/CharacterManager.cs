using UnityEngine;
using UnityEngine.Events;

// Garante que o GameObject tenha os componentes necessários
[RequireComponent(typeof(SpriteRenderer))]
[RequireComponent(typeof(CapsuleCollider2D))]
[RequireComponent(typeof(Rigidbody2D))]
[RequireComponent(typeof(Animator))]
[RequireComponent(typeof(Health))]
[RequireComponent(typeof(CharacterMovement))]
[RequireComponent(typeof(CharacterAnimation))]
public class CharacterManager : MonoBehaviour
{
	// ---------- COMPONENTES ----------
	[Header("Configurações do Personagem")]
	[Range(50f, 500f)]
	public float VelocidadeDeMovimento = 200;
	[Range(0f, 200f)]
	public float Vida = 100;
	[Range(0f, 50f)]
	public float Dano = 10;

	[Header("Configurações do Personagem (Jogador)")]
	[Range(50f, 500f)]
	public float ForçaDoPulo = 150;
	[Range(1f, 10f)]
	public float HitsPorSegundo = 2;
	[Range(.5f, 10f)]
	public float RaioDeAtaque = .75f;

	[Header("Configurações do Personagem (Inimigo)")]
	[Range(1f, 10f)]
	public float DistanciaParaSeguir = 3.5f;
	[Range(1f, 10f)]
	public float DistanciaParaAtacar = 2;

	[Header("Componentes do Personagem")]
	// Referência ao componente de vida do personagem
	// Responsável por armazenar e gerenciar a vida do personagem
	[SerializeField] protected Health _characterHealth;
	public CharacterMovement CharacterMovement;
	public CharacterAnimation CharacterAnimation;
	public CharacterCombat CharacterCombat;
	public Animator CharacterAnimator;
	
	public AudioManager AudioManager;
	// ---------- EVENTOS ----------

	// Evento que será disparado quando o personagem sofrer dano
	// Recebe um valor float representando a quantidade de dano
	public UnityEvent<float> OnTakingDamage;

	// ---------- MÉTODOS DO CICLO DE VIDA UNITY ----------

	// Chamado quando o GameObject é inicializado
	// Aqui adicionamos o listener para o evento de dano
	protected virtual void Awake()
	{
		_characterHealth = GetComponent<Health>();
		_characterHealth.MaxHealth = Vida;
		CharacterMovement = GetComponent<CharacterMovement>();
		CharacterAnimation = GetComponent<CharacterAnimation>();
		CharacterAnimator = GetComponent<Animator>();
		// Conecta o evento de dano do CharacterManager ao método TakeDamage do Health
		OnTakingDamage.AddListener(_characterHealth.TakeDamage);
	}
}

