using UnityEngine;

public class BossCombat : MonoBehaviour
{
    private Animator animator;
    private Transform player;
    private float attackRange = 5f;
    private float specialAttackRange = 7f;
    private float attackCooldown = 2f;
    private float specialAttackCooldown = 5f;
    private float lastAttackTime = 0f;
    private float lastSpecialAttackTime = 0f;

    void Start()
    {
        animator = GetComponent<Animator>();
        player = GameObject.FindGameObjectWithTag("Player").transform;
    }

    void Update()
    {
        // Kiểm tra khoảng cách với người chơi
        float distance = Vector3.Distance(player.position, transform.position);

        // Kiểm tra thời gian cooldown trước khi tấn công
        if (Time.time - lastAttackTime >= attackCooldown)
        {
            if (distance <= attackRange)
            {
                PerformAttack();
            }
        }

        if (Time.time - lastSpecialAttackTime >= specialAttackCooldown)
        {
            if (distance <= specialAttackRange)
            {
                PerformSpecialAttack();
            }
        }
    }

    // Phương thức tấn công
    public void PerformAttack()
    {
        // Kích hoạt trigger "Attack" trong Animator
        animator.SetBool("isAttacking", true);
        lastAttackTime = Time.time;
    }

    // Phương thức tấn công đặc biệt
    public void PerformSpecialAttack()
    {
        // Kích hoạt trigger "SpecialAttack" trong Animator
        animator.SetBool("isSpecialAttacking", true);
        lastSpecialAttackTime = Time.time;
    }
}
