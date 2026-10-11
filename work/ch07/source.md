<!-- PDF 163 | 书 141 -->
# Chapter 7: n-step Bootstrapping

In this chapter we unify the Monte Carlo (MC) methods and the one-step temporal-difference (TD) methods presented in the previous two chapters. Neither MC methods nor one-step TD methods are always the best. In this chapter we present n-step TD methods that generalize both methods so that one can shift from one to the other smoothly as needed to meet the demands of a particular task. n-step methods span a spectrum with MC methods at one end and one-step TD methods at the other. The best methods are often intermediate between the two extremes.

Another way of looking at the benefits of n-step methods is that they free you from the tyranny of the time step. With one-step TD methods the same time step determines how often the action can be changed and the time interval over which bootstrapping is done. In many applications one wants to be able to update the action very fast to take into account anything that has changed, but bootstrapping works best if it is over a length of time in which a significant and recognizable state change has occurred. With one-step TD methods, these time intervals are the same, and so a compromise must be made. n-step methods enable bootstrapping to occur over multiple steps, freeing us from the tyranny of the single time step.

The idea of n-step methods is usually used as an introduction to the algorithmic idea of eligibility traces (Chapter 12), which enable bootstrapping over multiple time intervals simultaneously. Here we instead consider the n-step bootstrapping idea on its own, postponing the treatment of eligibility-trace mechanisms until later. This allows us to separate the issues better, dealing with as many of them as possible in the simpler *n*-step setting.

As usual, we first consider the prediction problem and then the control problem. That is, we first consider how n-step methods can help in predicting returns as a function of state for a fixed policy (i.e., in estimating *v_π*). Then we extend the ideas to action values and control methods.

<!-- PDF 164 | 书 142 -->
## 7.1 n-step TD Prediction

What is the space of methods lying between Monte Carlo and TD methods? Consider estimating *v_π* from sample episodes generated using π. Monte Carlo methods perform an update for each state based on the entire sequence of observed rewards from that state until the end of the episode. The update of one-step TD methods, on the other hand, is based on just the one next reward, bootstrapping from the value of the state one step later as a proxy for the remaining rewards. One kind of intermediate method, then, would perform an update based on an intermediate number of rewards: more than one, but less than all of them until termination. For example, a two-step update would be based on the first two rewards and the estimated value of the state two steps later. Similarly, we could have three-step updates, four-step updates, and so on. Figure 7.1 shows the backup diagrams of the spectrum of n-step updates for *v_π*, with the one-step TD update on the left and the up-until-termination Monte Carlo update on the right.

[[FIG: 7.1]]
**Figure 7.1:** The backup diagrams of *n*-step methods. These methods form a spectrum ranging from one-step TD methods to Monte Carlo methods.

The methods that use n-step updates are still TD methods because they still change an earlier estimate based on how it differs from a later estimate. Now the later estimate is not one step later, but *n* steps later. Methods in which the temporal difference extends over *n* steps are called *n-step TD methods*. The TD methods introduced in the previous chapter all used one-step updates, which is why we called them one-step TD methods.

More formally, consider the update of the estimated value of state *S_t* as a result of the state–reward sequence, *S_t*, *R_{t+1}*, *S_{t+1}*, *R_{t+2}*, . . . , *R_T*, *S_T* (omitting the actions). We know that in Monte Carlo updates the estimate of *v_π*(*S_t*) is updated in the direction of the

<!-- PDF 165 | 书 143 -->
complete return:

[[EQ: (unnumbered p165-1)]]

where *T* is the last time step of the episode. Let us call this quantity the *target* of the update. Whereas in Monte Carlo updates the target is the return, in one-step updates the target is the first reward plus the discounted estimated value of the next state, which we call the *one-step return*:

[[EQ: (unnumbered p165-2)]]

where *V_t* : 𝒮 → ℝ here is the estimate at time *t* of *v_π*. The subscripts on *G_{t:t+1}* indicate that it is a truncated return for time *t* using rewards up until time *t*+1, with the discounted estimate γ*V_t*(*S_{t+1}*) taking the place of the other terms γ*R_{t+2}* + γ²*R_{t+3}* + · · · + γ^{T−t−1}*R_T* of the full return, as discussed in the previous chapter. Our point now is that this idea makes just as much sense after two steps as it does after one. The target for a two-step update is the *two-step return*:

[[EQ: (unnumbered p165-3)]]

where now γ²*V_{t+1}*(*S_{t+2}*) corrects for the absence of the terms γ²*R_{t+3}* + γ³*R_{t+4}* + · · · + γ^{T−t−1}*R_T*. Similarly, the target for an arbitrary *n*-step update is the *n-step return*:

[[EQ: (7.1)]]

for all *n*, *t* such that *n* ≥ 1 and 0 ≤ *t* < *T* − *n*. All n-step returns can be considered approximations to the full return, truncated after *n* steps and then corrected for the remaining missing terms by *V_{t+n−1}*(*S_{t+n}*). If *t* + *n* ≥ *T* (if the n-step return extends to or beyond termination), then all the missing terms are taken as zero, and the n-step return defined to be equal to the ordinary full return (*G_{t:t+n}* ≐ *G_t* if *t* + *n* ≥ *T*).

Note that *n*-step returns for *n* > 1 involve future rewards and states that are not available at the time of transition from *t* to *t* + 1. No real algorithm can use the n-step return until after it has seen *R_{t+n}* and computed *V_{t+n−1}*. The first time these are available is *t* + *n*. The natural state-value learning algorithm for using n-step returns is thus

[[EQ: (7.2)]]

while the values of all other states remain unchanged: *V_{t+n}*(*s*) = *V_{t+n−1}*(*s*), for all *s* ≠ *S_t*. We call this algorithm *n-step TD*. Note that no changes at all are made during the first *n* − 1 steps of each episode. To make up for that, an equal number of additional updates are made at the end of the episode, after termination and before starting the next episode. Complete pseudocode is given in the box on the next page.

*Exercise 7.1* In Chapter 6 we noted that the Monte Carlo error can be written as the sum of TD errors (6.6) if the value estimates don’t change from step to step. Show that the n-step error used in (7.2) can also be written as a sum of TD errors (again if the value estimates don’t change) generalizing the earlier result. <!-- 无星 -->

*Exercise 7.2 (programming)* With an n-step method, the value estimates do change from step to step, so an algorithm that used the sum of TD errors (see previous exercise) in

<!-- PDF 166 | 书 144 -->
place of the error in (7.2) would actually be a slightly different algorithm. Would it be a better algorithm or a worse one? Devise and program a small experiment to answer this question empirically. <!-- 无星 -->

<!-- BOX 开始：n-step TD for estimating V ≈ v_π -->
**n-step TD for estimating V ≈ v_π**

```
Input: a policy π
Algorithm parameters: step size α ∈ (0, 1], a positive integer n
Initialize V(s) arbitrarily, for all s ∈ S
All store and access operations (for S_t and R_t) can take their index mod n + 1

Loop for each episode:
    Initialize and store S_0 ≠ terminal
    T ← ∞
    Loop for t = 0, 1, 2, . . . :
    |   If t < T, then:
    |       Take an action according to π(·|S_t)
    |       Observe and store the next reward as R_{t+1} and the next state as S_{t+1}
    |       If S_{t+1} is terminal, then T ← t + 1
    |   τ ← t − n + 1    (τ is the time whose state's estimate is being updated)
    |   If τ ≥ 0:
    |       G ← Σ_{i=τ+1}^{min(τ+n,T)} γ^{i−τ−1}R_i
    |       If τ + n < T, then: G ← G + γⁿV(S_{τ+n})    (G_{τ:τ+n})
    |       V(S_τ) ← V(S_τ) + α[G − V(S_τ)]
    Until τ = T − 1
```
<!-- BOX 结束 -->

The n-step return uses the value function *V_{t+n−1}* to correct for the missing rewards beyond *R_{t+n}*. An important property of n-step returns is that their expectation is guaranteed to be a better estimate of *v_π* than *V_{t+n−1}* is, in a worst-state sense. That is, the worst error of the expected n-step return is guaranteed to be less than or equal to γ^*n* times the worst error under *V_{t+n−1}*:

[[EQ: (7.3)]]

for all *n* ≥ 1. This is called the *error reduction property* of n-step returns. Because of the error reduction property, one can show formally that all n-step TD methods converge to the correct predictions under appropriate technical conditions. The n-step TD methods thus form a family of sound methods, with one-step TD methods and Monte Carlo methods as extreme members.

<!-- 例题开始：Example 7.1: n-step TD Methods on the Random Walk -->
**Example 7.1: n-step TD Methods on the Random Walk** Consider using *n*-step TD methods on the 5-state random walk task described in Example 6.2 (page 125). Suppose the first episode progressed directly from the center state, C, to the right, through D and E, and then terminated on the right with a return of 1. Recall that the estimated values of all the states started at an intermediate value, *V*(*s*) = 0.5. As a result of this experience, a one-step method would change only the estimate for the last state,

<!-- PDF 167 | 书 145 -->
*V*(E), which would be incremented toward 1, the observed return. A two-step method, on the other hand, would increment the values of the two states preceding termination: *V*(D) and *V*(E) both would be incremented toward 1. A three-step method, or any n-step method for *n* > 2, would increment the values of all three of the visited states toward 1, all by the same amount.

Which value of *n* is better? Figure 7.2 shows the results of a simple empirical test for a larger random walk process, with 19 states instead of 5 (and with a −1 outcome on the left, all values initialized to 0), which we use as a running example in this chapter. Results are shown for n-step TD methods with a range of values for *n* and α. The performance measure for each parameter setting, shown on the vertical axis, is the square-root of the average squared error between the predictions at the end of the episode for the 19 states and their true values, then averaged over the first 10 episodes and 100 repetitions of the whole experiment (the same sets of walks were used for all parameter settings). Note that methods with an intermediate value of *n* worked best. This illustrates how the generalization of TD and Monte Carlo methods to n-step methods can potentially perform better than either of the two extreme methods.

[[FIG: 7.2]]
**Figure 7.2:** Performance of *n*-step TD methods as a function of α, for various values of *n*, on a 19-state random walk task (Example 7.1).
<!-- 例题结束 -->

*Exercise 7.3* Why do you think a larger random walk task (19 states instead of 5) was used in the examples of this chapter? Would a smaller walk have shifted the advantage to a different value of *n*? How about the change in left-side outcome from 0 to −1 made in the larger walk? Do you think that made any difference in the best value of *n*? <!-- 无星 -->

## 7.2 n-step Sarsa

How can n-step methods be used not just for prediction, but for control? In this section we show how n-step methods can be combined with Sarsa in a straightforward way to

<!-- PDF 168 | 书 146 -->
produce an on-policy TD control method. The *n*-step version of Sarsa we call *n-step Sarsa*, and the original version presented in the previous chapter we henceforth call *one-step Sarsa*, or *Sarsa(0)*.

The main idea is to simply switch states for actions (state–action pairs) and then use an ε-greedy policy. The backup diagrams for n-step Sarsa (shown in Figure 7.3), like those of n-step TD (Figure 7.1), are strings of alternating states and actions, except that the Sarsa ones all start and end with an action rather a state. We redefine *n*-step returns (update targets) in terms of estimated action values:

[[EQ: (7.4)]]

with *G_{t:t+n}* ≐ *G_t* if *t* + *n* ≥ *T*. The natural algorithm is then

[[EQ: (7.5)]]

while the values of all other states remain unchanged: *Q_{t+n}*(*s*, *a*) = *Q_{t+n−1}*(*s*, *a*), for all *s*, *a* such that *s* ≠ *S_t* or *a* ≠ *A_t*. This is the algorithm we call *n-step Sarsa*. Pseudocode is shown in the box on the next page, and an example of why it can speed up learning compared to one-step methods is given in Figure 7.4.

[[FIG: 7.3]]
**Figure 7.3:** The backup diagrams for the spectrum of *n*-step methods for state–action values. They range from the one-step update of Sarsa(0) to the up-until-termination update of the Monte Carlo method. In between are the *n*-step updates, based on *n* steps of real rewards and the estimated value of the *n*th next state–action pair, all appropriately discounted. On the far right is the backup diagram for *n*-step Expected Sarsa.

<!-- PDF 169 | 书 147 -->
<!-- BOX 开始：n-step Sarsa for estimating Q ≈ q_* or q_π -->
**n-step Sarsa for estimating Q ≈ q_* or q_π**

```
Initialize Q(s, a) arbitrarily, for all s ∈ S, a ∈ A
Initialize π to be ε-greedy with respect to Q, or to a fixed given policy
Algorithm parameters: step size α ∈ (0, 1], small ε > 0, a positive integer n
All store and access operations (for S_t, A_t, and R_t) can take their index mod n + 1

Loop for each episode:
    Initialize and store S_0 ≠ terminal
    Select and store an action A_0 ∼ π(·|S_0)
    T ← ∞
    Loop for t = 0, 1, 2, . . . :
    |   If t < T, then:
    |       Take action A_t
    |       Observe and store the next reward as R_{t+1} and the next state as S_{t+1}
    |       If S_{t+1} is terminal, then:
    |           T ← t + 1
    |       else:
    |           Select and store an action A_{t+1} ∼ π(·|S_{t+1})
    |   τ ← t − n + 1    (τ is the time whose estimate is being updated)
    |   If τ ≥ 0:
    |       G ← Σ_{i=τ+1}^{min(τ+n,T)} γ^{i−τ−1}R_i
    |       If τ + n < T, then G ← G + γⁿQ(S_{τ+n}, A_{τ+n})    (G_{τ:τ+n})
    |       Q(S_τ, A_τ) ← Q(S_τ, A_τ) + α[G − Q(S_τ, A_τ)]
    |       If π is being learned, then ensure that π(·|S_τ) is ε-greedy wrt Q
    Until τ = T − 1
```
<!-- BOX 结束 -->

[[FIG: 7.4]]
**Figure 7.4:** Gridworld example of the speedup of policy learning due to the use of *n*-step methods. The first panel shows the path taken by an agent in a single episode, ending at a location of high reward, marked by the G. In this example the values were all initially 0, and all rewards were zero except for a positive reward at G. The arrows in the other two panels show which action values were strengthened as a result of this path by one-step and n-step Sarsa methods. The one-step method strengthens only the last action of the sequence of actions that led to the high reward, whereas the n-step method strengthens the last *n* actions of the sequence, so that much more is learned from the one episode.

<!-- PDF 170 | 书 148 -->
*Exercise 7.4* Prove that the n-step return of Sarsa (7.4) can be written exactly in terms of a novel TD error, as

[[EQ: (7.6)]]

<!-- 无星 -->

What about Expected Sarsa? The backup diagram for the n-step version of Expected Sarsa is shown on the far right in Figure 7.3. It consists of a linear string of sample actions and states, just as in n-step Sarsa, except that its last element is a branch over all action possibilities weighted, as always, by their probability under π. This algorithm can be described by the same equation as n-step Sarsa (above) except with the n-step return redefined as

[[EQ: (7.7)]]

(with *G_{t:t+n}* ≐ *G_t* for *t* + *n* ≥ *T*) where *V̄_t*(*s*) is the *expected approximate value* of state *s*, using the estimated action values at time *t*, under the target policy:

[[EQ: (7.8)]]

Expected approximate values are used in developing many of the action-value methods in the rest of this book. If *s* is terminal, then its expected approximate value is defined to be 0.

## 7.3 n-step Off-policy Learning

Recall that off-policy learning is learning the value function for one policy, π, while following another policy, *b*. Often, π is the greedy policy for the current action-value-function estimate, and *b* is a more exploratory policy, perhaps ε-greedy. In order to use the data from *b* we must take into account the difference between the two policies, using their relative probability of taking the actions that were taken (see Section 5.5). In *n*-step methods, returns are constructed over *n* steps, so we are interested in the relative probability of just those *n* actions. For example, to make a simple off-policy version of *n*-step TD, the update for time *t* (actually made at time *t* + *n*) can simply be weighted by ρ_{t:t+n−1}:

[[EQ: (7.9)]]

where ρ_{t:t+n−1}, called the *importance sampling ratio*, is the relative probability under the two policies of taking the *n* actions from *A_t* to *A_{t+n−1}* (cf. Eq. 5.3):

[[EQ: (7.10)]]

<!-- PDF 171 | 书 149 -->
For example, if any one of the actions would never be taken by π (i.e., π(*A_k*|*S_k*) = 0) then the n-step return should be given zero weight and be totally ignored. On the other hand, if by chance an action is taken that π would take with much greater probability than *b* does, then this will increase the weight that would otherwise be given to the return. This makes sense because that action is characteristic of π (and therefore we want to learn about it) but is selected only rarely by *b* and thus rarely appears in the data. To make up for this we have to over-weight it when it does occur. Note that if the two policies are actually the same (the on-policy case) then the importance sampling ratio is always 1. Thus our new update (7.9) generalizes and can completely replace our earlier n-step TD update. Similarly, our previous n-step Sarsa update can be completely replaced by a simple off-policy form:

[[EQ: (7.11)]]

for 0 ≤ *t* < *T*. Note that the importance sampling ratio here starts and ends one step later than for n-step TD (7.9). This is because here we are updating a state–action pair. We do not have to care how likely we were to select the action; now that we have selected it we want to learn fully from what happens, with importance sampling only for subsequent actions. Pseudocode for the full algorithm is shown in the box below.

<!-- BOX 开始：Off-policy n-step Sarsa for estimating Q ≈ q_* or q_π -->
**Off-policy n-step Sarsa for estimating Q ≈ q_* or q_π**

```
Input: an arbitrary behavior policy b such that b(a|s) > 0, for all s ∈ S, a ∈ A
Initialize Q(s, a) arbitrarily, for all s ∈ S, a ∈ A
Initialize π to be greedy with respect to Q, or as a fixed given policy
Algorithm parameters: step size α ∈ (0, 1], a positive integer n
All store and access operations (for S_t, A_t, and R_t) can take their index mod n + 1

Loop for each episode:
    Initialize and store S_0 ≠ terminal
    Select and store an action A_0 ∼ b(·|S_0)
    T ← ∞
    Loop for t = 0, 1, 2, . . . :
    |   If t < T, then:
    |       Take action A_t
    |       Observe and store the next reward as R_{t+1} and the next state as S_{t+1}
    |       If S_{t+1} is terminal, then:
    |           T ← t + 1
    |       else:
    |           Select and store an action A_{t+1} ∼ b(·|S_{t+1})
    |   τ ← t − n + 1    (τ is the time whose estimate is being updated)
    |   If τ ≥ 0:
    |       ρ ← Π_{i=τ+1}^{min(τ+n,T−1)} π(A_i|S_i)/b(A_i|S_i)    (ρ_{τ+1:τ+n})
    |       G ← Σ_{i=τ+1}^{min(τ+n,T)} γ^{i−τ−1}R_i
    |       If τ + n < T, then: G ← G + γⁿQ(S_{τ+n}, A_{τ+n})    (G_{τ:τ+n})
    |       Q(S_τ, A_τ) ← Q(S_τ, A_τ) + αρ[G − Q(S_τ, A_τ)]
    |       If π is being learned, then ensure that π(·|S_τ) is greedy wrt Q
    Until τ = T − 1
```
<!-- BOX 结束 -->

<!-- PDF 172 | 书 150 -->
The off-policy version of *n*-step Expected Sarsa would use the same update as above for n-step Sarsa except that the importance sampling ratio would have one less factor in it. That is, the above equation would use ρ_{t+1:t+n−1} instead of ρ_{t+1:t+n}, and of course it would use the Expected Sarsa version of the n-step return (7.7). This is because in Expected Sarsa all possible actions are taken into account in the last state; the one actually taken has no effect and does not have to be corrected for.

## 7.4 *Per-decision Methods with Control Variates

The multi-step off-policy methods presented in the previous section are simple and conceptually clear, but are probably not the most efficient. A more sophisticated approach would use per-decision importance sampling ideas such as were introduced in Section 5.9. To understand this approach, first note that the ordinary n-step return (7.1), like all returns, can be written recursively. For the *n* steps ending at horizon *h*, the n-step return can be written

[[EQ: (7.12)]]

where *G_{h:h}* ≐ *V_{h−1}*(*S_h*). (Recall that this return is used at time *h*, previously denoted *t* + *n*.) Now consider the effect of following a behavior policy *b* that is not the same as the target policy π. All of the resulting experience, including the first reward *R_{t+1}* and the next state *S_{t+1}*, must be weighted by the importance sampling ratio for time *t*, ρ_t = π(*A_t*|*S_t*)/*b*(*A_t*|*S_t*). One might be tempted to simply weight the righthand side of the above equation, but one can do better. Suppose the action at time *t* would never be selected by π, so that ρ_t is zero. Then a simple weighting would result in the n-step return being zero, which could result in high variance when it was used as a target. Instead, in this more sophisticated approach, one uses an alternate, *off-policy* definition of the n-step return ending at horizon *h*, as

[[EQ: (7.13)]]

where again *G_{h:h}* ≐ *V_{h−1}*(*S_h*). In this approach, if ρ_t is zero, then instead of the target being zero and causing the estimate to shrink, the target is the same as the estimate and causes no change. The importance sampling ratio being zero means we should ignore the sample, so leaving the estimate unchanged seems appropriate. The second, additional term in (7.13) is called a *control variate* (for obscure reasons). Notice that the control variate does not change the expected update; the importance sampling ratio has expected value one (Section 5.9) and is uncorrelated with the estimate, so the expected value of the control variate is zero. Also note that the off-policy definition (7.13) is a strict generalization of the earlier on-policy definition of the n-step return (7.1), as the two are identical in the on-policy case, in which ρ_t is always 1.

For a conventional n-step method, the learning rule to use in conjunction with (7.13) is the n-step TD update (7.2), which has no explicit importance sampling ratios other than those embedded in the return.

*Exercise 7.5* Write the pseudocode for the off-policy state-value prediction algorithm described above. <!-- 无星 -->

<!-- PDF 173 | 书 151 -->
For action values, the off-policy definition of the n-step return is a little different because the first action does not play a role in the importance sampling. That first action is the one being learned; it does not matter if it was unlikely or even impossible under the target policy—it has been taken and now full unit weight must be given to the reward and state that follows it. Importance sampling will apply only to the actions that follow it.

First note that for action values the n-step *on-policy* return ending at horizon *h*, expectation form (7.7), can be written recursively just as in (7.12), except that for action values the recursion ends with *G_{h:h}* ≐ *V̄_{h−1}*(*S_h*) as in (7.8). An off-policy form with control variates is

[[EQ: (7.14)]]

If *h* < *T*, then the recursion ends with *G_{h:h}* ≐ *Q_{h−1}*(*S_h*, *A_h*), whereas, if *h* ≥ *T*, the recursion ends with and *G_{T−1:h}* ≐ *R_T*. The resultant prediction algorithm (after combining with (7.5)) is analogous to Expected Sarsa.
<!-- 本句原书印作 “the recursion ends with and”，其中的 `and` 照录原书 -->

*Exercise 7.6* Prove that the control variate in the above equations does not change the expected value of the return. <!-- 无星 -->

*Exercise 7.7* Write the pseudocode for the off-policy action-value prediction algorithm described immediately above. Pay particular attention to the termination conditions for the recursion upon hitting the horizon or the end of episode. <!-- 有星 -->

*Exercise 7.8* Show that the general (off-policy) version of the n-step return (7.13) can still be written exactly and compactly as the sum of state-based TD errors (6.5) if the approximate state value function does not change. <!-- 无星 -->

*Exercise 7.9* Repeat the above exercise for the action version of the off-policy n-step return (7.14) and the Expected Sarsa TD error (the quantity in brackets in Equation 6.9). <!-- 无星 -->

*Exercise 7.10 (programming)* Devise a small off-policy prediction problem and use it to show that the off-policy learning algorithm using (7.13) and (7.2) is more data efficient than the simpler algorithm using (7.1) and (7.9). <!-- 无星 -->

The importance sampling that we have used in this section, the previous section, and in Chapter 5, enables sound off-policy learning, but also results in high variance updates, forcing the use of a small step-size parameter and thereby causing learning to be slow. It is probably inevitable that off-policy training is slower than on-policy training—after all, the data is less relevant to what is being learned. However, it is probably also true that these methods can be improved on. The control variates are one way of reducing the variance. Another is to rapidly adapt the step sizes to the observed variance, as in the Autostep method (Mahmood, Sutton, Degris and Pilarski, 2012). Yet another promising approach is the invariant updates of Karampatziakis and Langford (2010) as extended to TD by Tian (in preparation). The usage technique of Mahmood (2017; Mahmood

<!-- PDF 174 | 书 152 -->
and Sutton, 2015) may also be part of the solution. In the next section we consider an off-policy learning method that does not use importance sampling.

## 7.5 Off-policy Learning Without Importance Sampling: The n-step Tree Backup Algorithm

Is off-policy learning possible without importance sampling? Q-learning and Expected Sarsa from Chapter 6 do this for the one-step case, but is there a corresponding multi-step algorithm? In this section we present just such an n-step method, called the *tree-backup algorithm*.

The idea of the algorithm is suggested by the 3-step tree-backup backup diagram shown to the right. Down the central spine and labeled in the diagram are three sample states and rewards, and two sample actions. These are the random variables representing the events occurring after the initial state–action pair *S_t*, *A_t*. Hanging off to the sides of each state are the actions that were *not* selected. (For the last state, all the actions are considered to have not (yet) been selected.) Because we have no sample data for the unselected actions, we bootstrap and use the estimates of their values in forming the target for the update. This slightly extends the idea of a backup diagram. So far we have always updated the estimated value of the node at the top of the diagram toward a target combining the rewards along the way (appropriately discounted) and the estimated values of the nodes at the bottom. In the tree-backup update, the target includes all these things plus the estimated values of the dangling action nodes hanging off the sides, at all levels. This is why it is called a *tree-backup update*; it is an update from the entire tree of estimated action values.

[[FIG: 7-inline-1]]
the 3-step tree-backup update

More precisely, the update is from the estimated action values of the *leaf nodes* of the tree. The action nodes in the interior, corresponding to the actual actions taken, do not participate. Each leaf node contributes to the target with a weight proportional to its probability of occurring under the target policy π. Thus each first-level action *a* contributes with a weight of π(*a*|*S_{t+1}*), except that the action actually taken, *A_{t+1}*, does not contribute at all. Its probability, π(*A_{t+1}*|*S_{t+1}*), is used to weight all the second-level action values. Thus, each non-selected second-level action *a*′ contributes with weight π(*A_{t+1}*|*S_{t+1}*)π(*a*′|*S_{t+2}*). Each third-level action contributes with weight π(*A_{t+1}*|*S_{t+1}*)π(*A_{t+2}*|*S_{t+2}*)π(*a*″|*S_{t+3}*), and so on. It is as if each arrow to an action node in the diagram is weighted by the action’s probability of being selected under the target policy and, if there is a tree below the action, then that weight applies to all the leaf nodes in the tree.

<!-- PDF 175 | 书 153 -->
We can think of the 3-step tree-backup update as consisting of 6 half-steps, alternating between sample half-steps from an action to a subsequent state, and expected half-steps considering from that state all possible actions with their probabilities of occurring under the policy.

Now let us develop the detailed equations for the n-step tree-backup algorithm. The one-step return (target) is the same as that of Expected Sarsa,

[[EQ: (7.15)]]

for *t* < *T* − 1, and the two-step tree-backup return is

[[EQ: (unnumbered p175-1)]]

for *t* < *T* − 2. The latter form suggests the general recursive definition of the tree-backup *n-step return*:

[[EQ: (7.16)]]

for *t* < *T* − 1, *n* ≥ 2, with the *n* = 1 case handled by (7.15) except for *G_{T−1:t+n}* ≐ *R_T*. This target is then used with the usual action-value update rule from n-step Sarsa:

[[EQ: (unnumbered p175-2)]]

for 0 ≤ *t* < *T*, while the values of all other state–action pairs remain unchanged: *Q_{t+n}*(*s*, *a*) = *Q_{t+n−1}*(*s*, *a*), for all *s*, *a* such that *s* ≠ *S_t* or *a* ≠ *A_t*. Pseudocode for this algorithm is shown in the box on the next page.

*Exercise 7.11* Show that if the approximate action values are unchanging, then the tree-backup return (7.16) can be written as a sum of expectation-based TD errors:

[[EQ: (unnumbered p175-3)]]

where δ_t ≐ *R_{t+1}* + γ*V̄_t*(*S_{t+1}*) − *Q*(*S_t*, *A_t*) and *V̄_t* is given by (7.8). <!-- 无星 -->

<!-- PDF 176 | 书 154 -->
<!-- BOX 开始：n-step Tree Backup for estimating Q ≈ q_* or q_π -->
**n-step Tree Backup for estimating Q ≈ q_* or q_π**

```
Initialize Q(s, a) arbitrarily, for all s ∈ S, a ∈ A
Initialize π to be greedy with respect to Q, or as a fixed given policy
Algorithm parameters: step size α ∈ (0, 1], a positive integer n
All store and access operations can take their index mod n + 1

Loop for each episode:
    Initialize and store S_0 ≠ terminal
    Choose an action A_0 arbitrarily as a function of S_0; Store A_0
    T ← ∞
    Loop for t = 0, 1, 2, . . . :
    |   If t < T:
    |       Take action A_t; observe and store the next reward and state as R_{t+1}, S_{t+1}
    |       If S_{t+1} is terminal:
    |           T ← t + 1
    |       else:
    |           Choose an action A_{t+1} arbitrarily as a function of S_{t+1}; Store A_{t+1}
    |   τ ← t + 1 − n    (τ is the time whose estimate is being updated)
    |   If τ ≥ 0:
    |       If t + 1 ≥ T:
    |           G ← R_T
    |       else
    |           G ← R_{t+1} + γΣ_a π(a|S_{t+1})Q(S_{t+1}, a)
    |       Loop for k = min(t, T − 1) down through τ + 1:
    |           G ← R_k + γΣ_{a≠A_k}π(a|S_k)Q(S_k, a) + γπ(A_k|S_k)G
    |       Q(S_τ, A_τ) ← Q(S_τ, A_τ) + α[G − Q(S_τ, A_τ)]
    |       If π is being learned, then ensure that π(·|S_τ) is greedy wrt Q
    Until τ = T − 1
```
<!-- BOX 结束 -->

## 7.6 *A Unifying Algorithm: n-step Q(σ)

So far in this chapter we have considered three different kinds of action-value algorithms, corresponding to the first three backup diagrams shown in Figure 7.5. n-step Sarsa has all sample transitions, the tree-backup algorithm has all state-to-action transitions fully branched without sampling, and n-step Expected Sarsa has all sample transitions except for the last state-to-action one, which is fully branched with an expected value. To what extent can these algorithms be unified?

One idea for unification is suggested by the fourth backup diagram in Figure 7.5. This is the idea that one might decide on a step-by-step basis whether one wanted to take the action as a sample, as in Sarsa, or consider the expectation over all actions instead, as in the tree-backup update. Then, if one chose always to sample, one would obtain Sarsa, whereas if one chose never to sample, one would get the tree-backup algorithm. Expected Sarsa would be the case where one chose to sample for all steps except for the last one.

<!-- PDF 177 | 书 155 -->
[[FIG: 7.5]]
**Figure 7.5:** The backup diagrams of the three kinds of *n*-step action-value updates considered so far in this chapter (4-step case) plus the backup diagram of a fourth kind of update that unifies them all. The label ‘ρ’ indicates half transitions on which importance sampling is required in the off-policy case. The fourth kind of update unifies all the others by choosing on a state-by-state basis whether to sample (σ_t = 1) or not (σ_t = 0).

And of course there would be many other possibilities, as suggested by the last diagram in the figure. To increase the possibilities even further we can consider a continuous variation between sampling and expectation. Let σ_t ∈ [0, 1] denote the degree of sampling on step *t*, with σ = 1 denoting full sampling and σ = 0 denoting a pure expectation with no sampling. The random variable σ_t might be set as a function of the state, action, or state–action pair at time *t*. We call this proposed new algorithm *n-step Q(σ)*.

Now let us develop the equations of *n*-step *Q*(σ). First we write the tree-backup *n*-step return (7.16) in terms of the horizon *h* = *t* + *n* and then in terms of the expected approximate value *V̄* (7.8):

[[EQ: (unnumbered p177-1)]]

after which it is exactly like the n-step return for Sarsa with control variates (7.14) except with the action probability π(*A_{t+1}*|*S_{t+1}*) substituted for the importance-sampling ratio ρ_{t+1}. For *Q*(σ), we slide linearly between these two cases:

[[EQ: (7.17)]]

<!-- PDF 178 | 书 156 -->
for *t* < *h* ≤ *T*. The recursion ends with *G_{h:h}* ≐ *Q_{h−1}*(*S_h*, *A_h*) if *h* < *T*, or with *G_{T−1:T}* ≐ *R_T* if *h* = *T*. Then we use the earlier update for n-step Sarsa without importance-sampling ratios (7.5) instead of (7.11), because now the ratios are incorporated in the n-step return. A complete algorithm is given in the box.

<!-- BOX 开始：Off-policy n-step Q(σ) for estimating Q ≈ q_* or q_π -->
**Off-policy n-step Q(σ) for estimating Q ≈ q_* or q_π**

```
Input: an arbitrary behavior policy b such that b(a|s) > 0, for all s ∈ S, a ∈ A
Initialize Q(s, a) arbitrarily, for all s ∈ S, a ∈ A
Initialize π to be greedy with respect to Q, or else it is a fixed given policy
Algorithm parameters: step size α ∈ (0, 1], a positive integer n
All store and access operations can take their index mod n + 1

Loop for each episode:
    Initialize and store S_0 ≠ terminal
    Choose and store an action A_0 ∼ b(·|S_0)
    T ← ∞
    Loop for t = 0, 1, 2, . . . :
    |   If t < T:
    |       Take action A_t; observe and store the next reward and state as R_{t+1}, S_{t+1}
    |       If S_{t+1} is terminal:
    |           T ← t + 1
    |       else:
    |           Choose and store an action A_{t+1} ∼ b(·|S_{t+1})
    |           Select and store σ_{t+1}
    |           Store π(A_{t+1}|S_{t+1})/b(A_{t+1}|S_{t+1}) as ρ_{t+1}
    |   τ ← t − n + 1    (τ is the time whose estimate is being updated)
    |   If τ ≥ 0:
    |       If t + 1 < T:
    |           G ← Q(S_{t+1}, A_{t+1})
    |       Loop for k = min(t + 1, T) down through τ + 1:
    |           if k = T:
    |               G ← R_T
    |           else:
    |               V̄ ← Σ_a π(a|S_k)Q(S_k, a)
    |               G ← R_k + γ(σ_kρ_k + (1 − σ_k)π(A_k|S_k))(G − Q(S_k, A_k)) + γV̄
    |       Q(S_τ, A_τ) ← Q(S_τ, A_τ) + α[G − Q(S_τ, A_τ)]
    |       If π is being learned, then ensure that π(·|S_τ) is greedy wrt Q
    Until τ = T − 1
```
<!-- BOX 结束 -->

<!-- PDF 179 | 书 157 -->
## 7.7 Summary

In this chapter we have developed a range of temporal-difference learning methods that lie in between the one-step TD methods of the previous chapter and the Monte Carlo methods of the chapter before. Methods that involve an intermediate amount of bootstrapping are important because they will typically perform better than either extreme.

Our focus in this chapter has been on n-step methods, which look ahead to the next *n* rewards, states, and actions. The two 4-step backup diagrams to the right together summarize most of the methods introduced. The state-value update shown is for *n*-step TD with importance sampling, and the action-value update is for *n-step Q(σ)*, which generalizes Expected Sarsa and Q-learning. All *n*-step methods involve a delay of *n* time steps before updating, as only then are all the required future events known. A further drawback is that they involve more computation per time step than previous methods. Compared to one-step methods, *n*-step methods also require more memory to record the states, actions, rewards, and sometimes other variables over the last *n* time steps. Eventually, in Chapter 12, we will see how multi-step TD methods can be implemented with minimal memory and computational complexity using eligibility traces, but there will always be some additional computation beyond one-step methods. Such costs can be well worth paying to escape the tyranny of the single time step.

[[FIG: 7-inline-2]]

Although n-step methods are more complex than those using eligibility traces, they have the great benefit of being conceptually clear. We have sought to take advantage of this by developing two approaches to off-policy learning in the n-step case. One, based on importance sampling is conceptually simple but can be of high variance. If the target and behavior policies are very different it probably needs some new algorithmic ideas before it can be efficient and practical. The other, based on tree-backup updates, is the natural extension of Q-learning to the multi-step case with stochastic target policies. It involves no importance sampling but, again if the target and behavior policies are substantially different, the bootstrapping may span only a few steps even if *n* is large.

<!-- PDF 180 | 书 158 -->
## Bibliographical and Historical Remarks

The notion of n-step returns is due to Watkins (1989), who also first discussed their error reduction property. *n*-step algorithms were explored in the first edition of this book, in which they were treated as of conceptual interest, but not feasible in practice. The work of Cichosz (1995) and particularly van Seijen (2016) showed that they are actually completely practical algorithms. Given this, and their conceptual clarity and simplicity, we have chosen to highlight them here in the second edition. In particular, we now postpone all discussion of the backward view and of eligibility traces until Chapter 12.

**7.1–2** The results in the random walk examples were made for this text based on work of Sutton (1988) and Singh and Sutton (1996). The use of backup diagrams to describe these and other algorithms in this chapter is new.

**7.3–5** The developments in these sections are based on the work of Precup, Sutton, and Singh (2000), Precup, Sutton, and Dasgupta (2001), and Sutton, Mahmood, Precup, and van Hasselt (2014).

The tree-backup algorithm is due to Precup, Sutton, and Singh (2000), but the presentation of it here is new.

**7.6** The *Q*(σ) algorithm is new to this text, but closely related algorithms have been explored further by De Asis, Hernandez-Garcia, Holland, and Sutton (2017).
