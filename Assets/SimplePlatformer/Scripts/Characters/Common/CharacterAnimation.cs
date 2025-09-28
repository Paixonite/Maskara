using UnityEngine;

public class CharacterAnimation : MonoBehaviour
{
	// ---------- COMPONENTES ----------

	// Referencia ao Animator do personagem, usado para controlar as animacoes
	[SerializeField] Animator _characterAnimator;

	private void Awake()
	{
		_characterAnimator = GetComponent<Animator>();
	}

	// ---------- METODOS DE ANIMACAO ----------

	// Define a animacao de movimento com base na velocidade do personagem
	public void SetMovementAnimation(float movement)
	{
		// Passa o valor absoluto da velocidade para o parametro "Speed"
		_characterAnimator.SetFloat("Speed", Mathf.Abs(movement));
	}

	// Define a animacao de movimento como true/false (usado para andar/parado)
	public void SetMovementAnimation(bool isWalking)
	{
		_characterAnimator.SetBool("IsWalking", isWalking);
	}

	// Define a animacao de pulo como true/false
	public void SetJumpingAnimation(bool isJumping)
	{
		_characterAnimator.SetBool("IsJumping", isJumping);
	}

	// Dispara a animacao de ataque
	public void SetAttackAnimation()
	{
		_characterAnimator.SetTrigger("Attack");
	}
}

