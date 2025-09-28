using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Events;

public class Health : MonoBehaviour
{
	// ---------- VARI�VEIS ----------

	// Valor atual da vida do personagem
	public float HealthValue;

	// Valor m�ximo de vida do personagem
	public float MaxHealth;

	// Refer�ncia ao Slider de UI que mostra a vida
	[SerializeField] Slider _healthSlider;

	// Evento disparado quando a vida chega a zero
	public UnityEvent OnDying;

	// ---------- M�TODOS DO CICLO DE VIDA UNITY ----------

	// Chamado quando o GameObject � inicializado
	private void Start()
	{
		// Inicializa a vida com o valor m�ximo
		HealthValue = MaxHealth;
	}

	// ---------- M�TODOS  ----------

	// Aplica dano ao personagem
	// Recebe um valor float representando o dano
	public void TakeDamage(float damage)
	{
		// Reduz a vida proporcional ao delta de f�sica
		HealthValue -= damage;

		// Atualiza a barra de vida na UI
		UpdateHealthBar();

		// Verifica se o personagem morreu
		if (HealthValue <= 0)
		{
			// Dispara o evento OnDying
			OnDying.Invoke();
		}
	}

	// Atualiza a barra de vida da UI, se houver
	void UpdateHealthBar()
	{
		if (_healthSlider != null)
		{
			_healthSlider.value = HealthValue / MaxHealth;
		}
	}
}

