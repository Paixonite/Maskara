using NUnit.Framework;
using UnityEngine;
using System.Collections.Generic;

public class EnemySpawner : MonoBehaviour
{
	[SerializeField] List<GameObject> _enemiesPrefab = new List<GameObject>();
    [SerializeField] List<Transform> _spawnPoints = new List<Transform>();
    [SerializeField] float _maxEnemies;
    int _enemiesIndex = 0;
    [SerializeField] float _spawnInterval;
    
    float _spawnDelay = 0;
 
    // Update is called once per frame
    void Update()
    {
        if(Time.time >= _spawnDelay)
        {
            if (_enemiesIndex < _maxEnemies)
            {
                SpawnEnemy();
                _spawnDelay = Time.time + 1f * _spawnInterval;
            }
        }
    }

    void SpawnEnemy()
    {
        int spawnPoint = Random.Range(0, _spawnPoints.Count);
        int enemyPrefabIndex = Random.Range(0, _enemiesPrefab.Count);
        GameObject enemy = Instantiate(_enemiesPrefab[enemyPrefabIndex], _spawnPoints[spawnPoint].position, Quaternion.identity, transform);
        _enemiesIndex++;
    }

	void OnDrawGizmos()
	{
        foreach(Transform t in _spawnPoints)
        {
			Gizmos.color = Color.blue;
			Gizmos.DrawWireSphere(t.position, 1f);
		}		
	}
}
