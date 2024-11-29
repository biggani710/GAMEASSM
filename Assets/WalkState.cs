using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Unity.AI;
using UnityEngine.AI;

public class WalkState : StateMachineBehaviour
{
    float time;
    float chaseRange = 8;
    Transform player;
    List<Transform> waypoints = new List<Transform>();
    NavMeshAgent agent;
    // OnStateEnter is called when a transition starts and the state machine starts to evaluate this state
    override public void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        time = 0;
        agent = animator.gameObject.transform.parent.GetComponent<NavMeshAgent>();
        GameObject gameobject = GameObject.FindGameObjectWithTag("Waypoint");
        foreach (Transform tran in gameobject.transform)
        {
            waypoints.Add(tran);
        }
        agent.SetDestination(
            waypoints[Random.Range(0,waypoints.Count)].position
         );
    }

    // OnStateUpdate is called on each Update frame between OnStateEnter and OnStateExit callbacks
    override public void OnStateUpdate(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        time+= Time.deltaTime;
        if (time > 5) //sau 5 giay thi se co tuan tra la false
            animator.SetBool("isPatrolling", false);
        if (agent.remainingDistance <= agent.stoppingDistance)
            agent.SetDestination(
                waypoints[Random.Range(0, waypoints.Count)].position);

        float distance = Vector3.Distance(player.position,
                                        animator.transform.position);
        if (distance <= chaseRange)// neu 2 dua gan nhau se bat dau co truy duoi
        {
            animator.SetBool("isChasing", true);
        }
    }

    // OnStateExit is called when a transition ends and the state machine finishes evaluating this state
    override public void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        agent.SetDestination(agent.transform.position);
    }

    // OnStateMove is called right after Animator.OnAnimatorMove()
    //override public void OnStateMove(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    //{
    //    // Implement code that processes and affects root motion
    //}

    // OnStateIK is called right after Animator.OnAnimatorIK()
    //override public void OnStateIK(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    //{
    //    // Implement code that sets up animation IK (inverse kinematics)
    //}
}
