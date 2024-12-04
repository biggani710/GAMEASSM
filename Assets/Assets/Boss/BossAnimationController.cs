using UnityEngine;

public class BossAnimationController : MonoBehaviour
{
    private Animator animator;
    private Transform player;
    private float distanceToPlayer;
    private float attackRange = 5f;  // Khoảng cách tấn công
    private float specialAttackRange = 7f; // Khoảng cách tấn công đặc biệt
    private float chaseRange = 8f; // Khoảng cách để bắt đầu truy đuổi
    private bool isDead = false;

    void Start()
    {
        animator = GetComponent<Animator>();
        player = GameObject.FindGameObjectWithTag("Player").transform;
    }

    void Update()
    {
        if (isDead)
            return;  // Nếu boss đã chết, không thực hiện hành động gì nữa

        distanceToPlayer = Vector3.Distance(transform.position, player.position);

        // Kiểm tra khoảng cách và cập nhật trạng thái của boss
        if (distanceToPlayer <= attackRange)
        {
            // Nếu trong phạm vi tấn công, kích hoạt tấn công
            animator.SetBool("isAttacking", true);
            animator.SetBool("isSpecialAttacking", false);  // Tắt tấn công đặc biệt
        }
        else if (distanceToPlayer <= specialAttackRange)
        {
            // Nếu trong phạm vi tấn công đặc biệt
            animator.SetBool("isSpecialAttacking", true);
            animator.SetBool("isAttacking", false);  // Tắt tấn công thường
        }
        else if (distanceToPlayer <= chaseRange)
        {
            // Nếu trong phạm vi truy đuổi, kích hoạt trạng thái chasing
            animator.SetBool("isChasing", true);
            animator.SetBool("isWalking", true);
            animator.SetBool("isAttacking", false);  // Tắt trạng thái tấn công
            animator.SetBool("isSpecialAttacking", false);  // Tắt trạng thái tấn công đặc biệt
        }
        else
        {
            // Nếu không ở trong phạm vi tấn công hoặc truy đuổi, chuyển sang trạng thái Idle
            animator.SetBool("isChasing", false);
            animator.SetBool("isWalking", false);
            animator.SetBool("isAttacking", false);
            animator.SetBool("isSpecialAttacking", false);
        }

        // Nếu boss chết, chuyển trạng thái Death
        if (isDead)
        {
            animator.SetBool("isDead", true);
        }
    }

    // Gọi hàm này khi boss chết (có thể từ một event hoặc trigger)
    public void Die()
    {
        isDead = true;
    }
}
