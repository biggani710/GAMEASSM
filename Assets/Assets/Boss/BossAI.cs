using System.Collections;
using UnityEngine;
using UnityEngine.AI;

public class BossAI : MonoBehaviour
{
    public Transform player; // Vị trí người chơi
    public GameObject minionPrefab; // Prefab quái triệu hồi
    public Transform[] summonPoints; // Vị trí triệu hồi quái
    public GameObject aoePrefab; // Prefab đòn tấn công diện rộng
    public Transform aoeCenter; // Trung tâm của đòn diện rộng
    public float aoeRadius = 5f; // Bán kính đòn diện rộng
    public int aoeDamage = 20; // Sát thương đòn diện rộng
    public float specialCooldown = 10f; // Thời gian hồi chiêu đặc biệt
    private float lastSpecialTime = 0f;
    private NavMeshAgent navMeshAgent; // Agent để quản lý di chuyển của boss
    private Animator animator;
    private AtributesManager attributesManager; // Quản lý thuộc tính của boss

    void Start()
    {
        animator = GetComponent<Animator>();
        attributesManager = GetComponent<AtributesManager>();
        navMeshAgent = GetComponent<NavMeshAgent>(); // Lấy NavMeshAgent
    }

    void Update()
    {
        if (attributesManager.heath <= 0)
        {
            return; // Boss đã chết, không thực hiện hành động
        }
        // Cập nhật trạng thái di chuyển
        bool isMoving = navMeshAgent.velocity.magnitude > 0.1f;
        animator.SetBool("isWalking", isMoving);
        // Kiểm tra hồi chiêu và thực hiện chiêu đặc biệt
        if (Time.time - lastSpecialTime > specialCooldown)
        {
            PerformSpecialAttack();
            lastSpecialTime = Time.time;
        }
    }

    void HealBoss(int amount)
    {
        attributesManager.heath = Mathf.Min(attributesManager.heath + amount, 100); // Giới hạn máu tối đa
        Debug.Log($"Boss healed by {amount}. Current health: {attributesManager.heath}");
    }

    void PerformSpecialAttack()
    {
        if (UnityEngine.Random.value > 0.5f)
        {
            StartCoroutine(SummonMinions());
        }
        else
        {
            StartCoroutine(AOEAttack());
        }
    }

    IEnumerator SummonMinions()
    {
        animator.SetTrigger("Special"); // Kích hoạt hoạt ảnh đặc biệt
        yield return new WaitForSeconds(animator.GetCurrentAnimatorStateInfo(0).length); // Đợi hoạt ảnh kết thúc

        foreach (var point in summonPoints)
        {
            Instantiate(minionPrefab, point.position, Quaternion.identity); // Triệu hồi quái
        }
    }


    IEnumerator AOEAttack()
    {
        animator.SetTrigger("Special"); // Hoạt ảnh đặc biệt
        yield return new WaitForSeconds(1.5f); // Thời gian hoạt ảnh

        GameObject aoeEffect = Instantiate(aoePrefab, aoeCenter.position, Quaternion.identity);
        Collider[] hitObjects = Physics.OverlapSphere(aoeCenter.position, aoeRadius);

        foreach (Collider hit in hitObjects)
        {
            var targetAttributes = hit.GetComponent<AtributesManager>();
            if (targetAttributes != null && hit.CompareTag("Player"))
            {
                targetAttributes.TakeDamage(aoeDamage);
            }
        }

        Destroy(aoeEffect, 2f); // Hủy hiệu ứng sau 2 giây
    }
}
