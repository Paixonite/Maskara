using UnityEngine;
using UnityEngine.Events;

public class CharacterMovement : MonoBehaviour
{
	// ---------- COMPONENTS ----------

	// Referencia ao Rigidbody2D do personagem
	// Usado para aplicar fisica (movimento, colisoes etc.)
	[SerializeField] Rigidbody2D _characterRigidbody;

	[SerializeField] CharacterManager _characterManager;

	// ---------- ATRIBUTOS DE MOVIMENTO ----------

	// Velocidade base de movimento do personagem
	[SerializeField] float _moveSpeed = 200;
	// Metodo getter para acessar a velocidade de movimento de fora da classe
	public float GetMoveSpeed() { return _moveSpeed; }

	// Forca vertical aplicada ao personagem ao pular
	[SerializeField] float _jumpMagnitude = 150f;

	// Suavizacao do movimento (usada no SmoothDamp para nao ser instantaneo)
	[SerializeField] float _movementSmoothing = 0.1f;


	// ---------- ATRIBUTOS DE PULO E COLISAO ----------

	// Indica se o personagem esta tocando o chao
	[SerializeField] bool _isGrounded = false;

	// Se verdadeiro, o personagem pode ser controlado mesmo no ar
	[SerializeField] bool _isAirControlled = true;

	// Define quais layers sao consideradas como "chao"
	[SerializeField] LayerMask _groundLayerMask;

	// Tamanho do box usado para checar o chao
	[SerializeField] float _groundCheckboxSize = 1.0f;

	// Distancia do cast para baixo na deteccao de chao
	[SerializeField] float _groundCheckboxCastDistance = .5f;


	// ---------- VARIAVEIS INTERNAS ----------

	// Velocidade usada no SmoothDamp para suavizar o movimento
	Vector2 _velocity = Vector2.zero;

	// Indica se o personagem esta virado para a direita (true) ou esquerda (false)
	[SerializeField] bool _isFacingRight = true;


	// ---------- EVENTOS ----------

	// Evento disparado quando o personagem aterrissa no chao
	public UnityEvent<bool> OnLanding;


	// ---------- METODOS UNITY ----------

	private void Start()
	{
		_characterManager = GetComponent<CharacterManager>();
		_characterRigidbody = GetComponent<Rigidbody2D>();
		_groundLayerMask = LayerMask.GetMask("Ground");
		OnLanding.AddListener(_characterManager.CharacterAnimation.SetJumpingAnimation);

		_moveSpeed = _characterManager.VelocidadeDeMovimento;
		_jumpMagnitude = _characterManager.ForçaDoPulo;

	}

	// FixedUpdate eh chamado em intervalos fixos (sincronizado com a fisica)
	private void FixedUpdate()
	{
		// Verifica constantemente se o personagem esta tocando o chao
		IsGrounded();
	}


	// ---------- METODOS DE MOVIMENTO ----------

	// Metodo responsavel por aplicar movimento e pulo no personagem
	public void Move(float moveSpeed, bool jump)
	{
		// So pode mover no ar se _isAirControlled for verdadeiro
		if (_isGrounded || _isAirControlled)
		{
			// Calcula a velocidade alvo (mantendo a velocidade vertical atual)
			Vector2 targetVelocity = new Vector2(moveSpeed, _characterRigidbody.linearVelocity.y);

			// Suaviza a transicao da velocidade atual para a alvo
			_characterRigidbody.linearVelocity =
				Vector2.SmoothDamp(_characterRigidbody.linearVelocity, targetVelocity, ref _velocity, _movementSmoothing);
			
			// Inverte a sprite se o personagem mudar de direcao
			if (moveSpeed > 0.0f && !_isFacingRight)
			{
				Flip();
			}
			else if (moveSpeed < 0.0f && _isFacingRight)
			{
				Flip();
			}
		}

		// Se esta no chao e recebeu comando de pulo
		if (_isGrounded && jump)
		{
			_isGrounded = false; // reseta flag
								 // Aplica forca vertical para pular
			_characterRigidbody.AddForce(new Vector2(0, _jumpMagnitude));
		}
	}


	// ---------- METODOS DE DETECCAO ----------

	// Verifica se o personagem esta tocando o chao
	void IsGrounded()
	{
		// Salva o estado anterior para detectar transicao "no ar -> chao"
		bool wasGrounded = _isGrounded;
		_isGrounded = false;

		// Faz um BoxCast para baixo para checar colisao com o chao
		RaycastHit2D hit = Physics2D.BoxCast(
			transform.position,                                    // origem
			new Vector2(_groundCheckboxSize, _groundCheckboxSize), // tamanho da caixa
			0,                                                     // sem rotacao
			Vector2.down,                                          // direcao (para baixo)
			_groundCheckboxCastDistance,                           // distancia
			_groundLayerMask                                       // layers validas (chao)
		);

		// Se colidiu, significa que esta no chao
		if (hit.collider != null)
		{
			_isGrounded = true;

			// Se antes estava no ar e agora aterrissou, dispara evento
			if (!wasGrounded)
			{
				OnLanding?.Invoke(false);
			}
		}
	}


	// ---------- METODOS AUXILIARES ----------

	// Inverte a orientacao do personagem (virar sprite para o outro lado)
	void Flip()
	{
		_isFacingRight = !_isFacingRight; // inverte flag

		// Inverte a escala no eixo X para virar o sprite
		Vector3 characterScale = transform.localScale;
		characterScale.x *= -1;
		transform.localScale = characterScale;
	}


	// ---------- DEBUG ----------

	// Desenha no editor a area usada pelo BoxCast do chao
	void OnDrawGizmos()
	{
		Gizmos.DrawWireCube(
			transform.position - transform.up * _groundCheckboxCastDistance,
			Vector3.one * _groundCheckboxSize
		);
	}
}


