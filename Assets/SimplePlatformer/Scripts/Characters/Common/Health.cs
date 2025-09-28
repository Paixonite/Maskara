using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Events;

public class Health : MonoBehaviour
{
	// ---------- VARIÁVEIS ----------

	// Valor atual da vida do personagem
	public float HealthValue;

	// Valor máximo de vida do personagem
	public float MaxHealth;

	// Referência ao Slider de UI que mostra a vida
	[SerializeField] Slider _healthSlider;

	// Evento disparado quando a vida chega a zero
	public UnityEvent OnDying;

	// ---------- MÉTODOS DO CICLO DE VIDA UNITY ----------

	// Chamado quando o GameObject é inicializado
	private void Start()
	{
		// Inicializa a vida com o valor máximo
		HealthValue = MaxHealth;
	}

	// ---------- MÉTODOS  ----------

	// Aplica dano ao personagem
	// Recebe um valor float representando o dano
	public void TakeDamage(float damage)
	{
		// Reduz a vida proporcional ao delta de física
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

