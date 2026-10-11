<!-- PDF 309 | 书 287 -->
# Chapter 12: Eligibility Traces

Eligibility traces are one of the basic mechanisms of reinforcement learning. For example, in the popular TD(λ) algorithm, the λ refers to the use of an eligibility trace. Almost any temporal-difference (TD) method, such as Q-learning or Sarsa, can be combined with eligibility traces to obtain a more general method that may learn more efficiently.

Eligibility traces unify and generalize TD and Monte Carlo methods. When TD methods are augmented with eligibility traces, they produce a family of methods spanning a spectrum that has Monte Carlo methods at one end (λ=1) and one-step TD methods at the other (λ = 0). In between are intermediate methods that are often better than either extreme method. Eligibility traces also provide a way of implementing Monte Carlo methods online and on continuing problems without episodes.

Of course, we have already seen one way of unifying TD and Monte Carlo methods: the n-step TD methods of Chapter 7. What eligibility traces offer beyond these is an elegant algorithmic mechanism with significant computational advantages. The mechanism is a short-term memory vector, the eligibility trace z_t ∈ ℝ^d, that parallels the long-term weight vector w_t ∈ ℝ^d. The rough idea is that when a component of w_t participates in producing an estimated value, then the corresponding component of z_t is bumped up and then begins to fade away. Learning will then occur in that component of w_t if a nonzero TD error occurs before the trace falls back to zero. The trace-decay parameter λ ∈ [0, 1] determines the rate at which the trace falls.

The primary computational advantage of eligibility traces over n-step methods is that only a single trace vector is required rather than a store of the last n feature vectors. Learning also occurs continually and uniformly in time rather than being delayed and then catching up at the end of the episode. In addition learning can occur and affect behavior immediately after a state is encountered rather than being delayed n steps.

Eligibility traces illustrate that a learning algorithm can sometimes be implemented in a different way to obtain computational advantages. Many algorithms are most naturally formulated and understood as an update of a state’s value based on events that follow that state over multiple future time steps. For example, Monte Carlo methods (Chapter 5) update a state based on all the future rewards, and n-step TD methods (Chapter 7)

<!-- PDF 310 | 书 288 -->
update based on the next n rewards and state n steps in the future. Such formulations, based on looking forward from the updated state, are called forward views. Forward views are always somewhat complex to implement because the update depends on later things that are not available at the time. However, as we show in this chapter it is often possible to achieve nearly the same updates—and sometimes exactly the same updates—with an algorithm that uses the current TD error, looking backward to recently visited states using an eligibility trace. These alternate ways of looking at and implementing learning algorithms are called backward views. Backward views, transformations between forward views and backward views, and equivalences between them, date back to the introduction of temporal difference learning but have become much more powerful and sophisticated since 2014. Here we present the basics of the modern view.

As usual, first we fully develop the ideas for state values and prediction, then extend them to action values and control. We develop them first for the on-policy case then extend them to off-policy learning. Our treatment pays special attention to the case of linear function approximation, for which the results with eligibility traces are stronger. All these results apply also to the tabular and state aggregation cases because these are special cases of linear function approximation.

## 12.1 The λ-return

In Chapter 7 we defined an n-step return as the sum of the first n rewards plus the estimated value of the state reached in n steps, each appropriately discounted (7.1). The general form of that equation, for any parameterized function approximator, is

[[EQ: (12.1)]]

where v̂(s, w) is the approximate value of state s given weight vector w (Chapter 9), and T is the time of episode termination, if any. We noted in Chapter 7 that each n-step return, for n ≥ 1, is a valid update target for a tabular learning update, just as it is for an approximate SGD learning update such as (9.7).

Now we note that a valid update can be done not just toward any n-step return, but toward any average of n-step returns for different ns. For example, an update can be done toward a target that is half of a two-step return and half of a four-step return: 1/2 G_{t:t+2} + 1/2 G_{t:t+4}. Any set of n-step returns can be averaged in this way, even an infinite set, as long as the weights on the component returns are positive and sum to 1. The composite return possesses an error reduction property similar to that of individual n-step returns (7.3) and thus can be used to construct updates with guaranteed convergence properties. Averaging produces a substantial new range of algorithms. For example, one could average one-step and infinite-step returns to obtain another way of interrelating TD and Monte Carlo methods. In principle, one could even average experience-based updates with DP updates to get a simple combination of experience-based and model-based methods (cf. Chapter 8).

An update that averages simpler component updates is called a *compound update*. The backup diagram for a compound update consists of the backup diagrams for each of the component updates with a horizontal line above them and the weighting fractions below.

<!-- PDF 311 | 书 289 -->
For example, the compound update for the case mentioned at the start of this section, mixing half of a two-step return and half of a four-step return, has the diagram shown to the right. A compound update can only be done when the longest of its component updates is complete. The update at the right, for example, could only be done at time *t*+4 for the estimate formed at time *t*. In general one would like to limit the length of the longest component update because of the corresponding delay in the updates.

[[FIG: 12-inline-1]]

The TD(λ) algorithm can be understood as one particular way of averaging n-step updates. This average contains all the n-step updates, each weighted proportionally to λ^{n−1} (where λ ∈ [0, 1)), and is normalized by a factor of 1 − λ to ensure that the weights sum to 1 (Figure 12.1). The resulting update is toward a return, called the *λ-return*, defined in its state-based form by

[[EQ: (12.2)]]

Figure 12.2 further illustrates the weighting on the sequence of n-step returns in the λ-return. The one-step return is given the largest weight, 1 − λ; the two-step return is given the next largest weight, (1 − λ)λ; the three-step return is given the weight (1 − λ)λ²; and so on. The weight fades by λ with each additional step. After a terminal state has been reached, all subsequent n-step returns are equal to the conventional return, G_t. If

[[FIG: 12.1]]
**Figure 12.1:** The backup diagram for TD(λ). If λ = 0, then the overall update reduces to its first component, the one-step TD update, whereas if λ = 1, then the overall update reduces to its last component, the Monte Carlo update.

<!-- PDF 312 | 书 290 -->
[[FIG: 12.2]]
**Figure 12.2:** Weighting given in the λ-return to each of the n-step returns.

we want, we can separate these post-termination terms from the main sum, yielding

[[EQ: (12.3)]]

as indicated in the figures. This equation makes it clearer what happens when λ = 1. In this case the main sum goes to zero, and the remaining term reduces to the conventional return. Thus, for λ = 1, updating according to the λ-return is a Monte Carlo algorithm. On the other hand, if λ = 0, then the λ-return reduces to G_{t:t+1}, the one-step return. Thus, for λ = 0, updating according to the λ-return is a one-step TD method.

*Exercise 12.1* Just as the return can be written recursively in terms of the first reward and itself one-step later (3.9), so can the λ-return. Derive the analogous recursive relationship from (12.2) and (12.1). <!-- 无星 -->

*Exercise 12.2* The parameter λ characterizes how fast the exponential weighting in Figure 12.2 falls off, and thus how far into the future the λ-return algorithm looks in determining its update. But a rate factor such as λ is sometimes an awkward way of characterizing the speed of the decay. For some purposes it is better to specify a time constant, or half-life. What is the equation relating λ and the half-life, τ_λ, the time by which the weighting sequence will have fallen to half of its initial value? <!-- 无星 -->

We are now ready to define our first learning algorithm based on the λ-return: the *off-line λ-return algorithm*. As an off-line algorithm, it makes no changes to the weight vector during the episode. Then, at the end of the episode, a whole sequence of off-line updates are made according to our usual semi-gradient rule, using the λ-return as the target:

[[EQ: (12.4)]]

<!-- PDF 313 | 书 291 -->
The λ-return gives us an alternative way of moving smoothly between Monte Carlo and one-step TD methods that can be compared with the n-step bootstrapping way developed in Chapter 7. There we assessed effectiveness on a 19-state random walk task (Example 7.1, page 144). Figure 12.3 shows the performance of the off-line λ-return algorithm on this task alongside that of the n-step methods (repeated from Figure 7.2). The experiment was just as described earlier except that for the λ-return algorithm we varied λ instead of n. The performance measure used is the estimated root-mean-square error between the correct and estimated values of each state measured at the end of the episode, averaged over the first 10 episodes and the 19 states. Note that overall performance of the off-line λ-return algorithms is comparable to that of the n-step algorithms. In both cases we get best performance with an intermediate value of the bootstrapping parameter, n for n-step methods and λ for the off-line λ-return algorithm.

[[FIG: 12.3]]
**Figure 12.3:** 19-state Random walk results (Example 7.1): Performance of the off-line λ-return algorithm alongside that of the n-step TD methods. In both case, intermediate values of the bootstrapping parameter (λ or n) performed best. The results with the off-line λ-return algorithm are slightly better at the best values of α and λ, and at high α.

The approach that we have been taking so far is what we call the theoretical, or *forward*, view of a learning algorithm. For each state visited, we look forward in time to all the future rewards and decide how best to combine them. We might imagine ourselves riding the stream of states, looking forward from each state to determine its update, as suggested by Figure 12.4. After looking forward from and updating one state, we move on to the next and never have to work with the preceding state again. Future states, on the other hand, are viewed and processed repeatedly, once from each vantage point preceding them.

<!-- PDF 314 | 书 292 -->
[[FIG: 12.4]]
**Figure 12.4:** The forward view. We decide how to update each state by looking forward to future rewards and states.

## 12.2 TD(λ)

TD(λ) is one of the oldest and most widely used algorithms in reinforcement learning. It was the first algorithm for which a formal relationship was shown between a more theoretical forward view and a more computationally-congenial backward view using eligibility traces. Here we will show empirically that it approximates the off-line λ-return algorithm presented in the previous section.

TD(λ) improves over the off-line λ-return algorithm in three ways. First it updates the weight vector on every step of an episode rather than only at the end, and thus its estimates may be better sooner. Second, its computations are equally distributed in time rather than all at the end of the episode. And third, it can be applied to continuing problems rather than just to episodic problems. In this section we present the semi-gradient version of TD(λ) with function approximation.

With function approximation, the eligibility trace is a vector z_t ∈ ℝ^d with the same number of components as the weight vector w_t. Whereas the weight vector is a long-term memory, accumulating over the lifetime of the system, the eligibility trace is a short-term memory, typically lasting less time than the length of an episode. Eligibility traces assist in the learning process; their only consequence is that they affect the weight vector, and then the weight vector determines the estimated value.

In TD(λ), the eligibility trace vector is initialized to zero at the beginning of the episode, is incremented on each time step by the value gradient, and then fades away by γλ:

[[EQ: (12.5)]]

where γ is the discount rate and λ is the parameter introduced in the previous section, which we henceforth call the *trace-decay parameter*. The eligibility trace keeps track of which components of the weight vector have contributed, positively or negatively, to recent state valuations, where “recent” is defined in terms of γλ. (Recall that in linear function approximation, ∇v̂(S_t, w_t) is the feature vector, x_t, in which case the eligibility trace vector is just a sum of past, fading, input vectors.) The trace is said to indicate the eligibility of each component of the weight vector for undergoing learning changes

<!-- PDF 315 | 书 293 -->
should a reinforcing event occur. The reinforcing events we are concerned with are the moment-by-moment one-step TD errors. The TD error for state-value prediction is

[[EQ: (12.6)]]

In TD(λ), the weight vector is updated on each step proportional to the scalar TD error and the vector eligibility trace:

[[EQ: (12.7)]]

<!-- BOX 开始：Semi-gradient TD(λ) for estimating v̂ ≈ v_π -->
**Semi-gradient TD(λ) for estimating v̂ ≈ v_π**

```
Input: the policy π to be evaluated
Input: a differentiable function v̂ : 𝒮⁺ × ℝ^d → ℝ such that v̂(terminal, ·) = 0
Algorithm parameters: step size α > 0, trace decay rate λ ∈ [0, 1]
Initialize value-function weights w arbitrarily (e.g., w = 0)

Loop for each episode:
    Initialize S
    z ← 0 (a d-dimensional vector)
    Loop for each step of episode:
        Choose A ∼ π(·|S)
        Take action A, observe R, S′
        z ← γλz + ∇v̂(S, w)
        δ ← R + γv̂(S′, w) − v̂(S, w)
        w ← w + αδz
        S ← S′
    until S′ is terminal
```
<!-- BOX 结束 -->

[[FIG: 12.5]]
**Figure 12.5:** The backward or mechanistic view of TD(λ). Each update depends on the current TD error combined with the current eligibility traces of past events.

<!-- PDF 316 | 书 294 -->
TD(λ) is oriented backward in time. At each moment we look at the current TD error and assign it backward to each prior state according to how much that state contributed to the current eligibility trace at that time. We might imagine ourselves riding along the stream of states, computing TD errors, and shouting them back to the previously visited states, as suggested by Figure 12.5. Where the TD error and traces come together, we get the update given by (12.7), changing the values of those past states for when they occur again in the future.

To better understand the backward view of TD(λ), consider what happens at various values of λ. If λ = 0, then by (12.5) the trace at t is exactly the value gradient corresponding to S_t. Thus the TD(λ) update (12.7) reduces to the one-step semi-gradient TD update treated in Chapter 9 (and, in the tabular case, to the simple TD rule (6.2)). This is why that algorithm was called TD(0). In terms of Figure 12.5, TD(0) is the case in which only the one state preceding the current one is updated by the TD error (other states may have their value estimates changed by generalization due to function approximation). For larger values of λ, but still λ < 1, more of the preceding states are updated, but each more temporally distant state is updated less because the corresponding eligibility trace is smaller, as suggested by the figure. We say that the earlier states are given less credit for the TD error.

If λ = 1, then the credit given to earlier states falls only by γ per step. This turns out to be just the right thing to do to achieve Monte Carlo behavior. For example, remember that the TD error, δ_t, includes an undiscounted term of R_{t+1}. In passing this back k steps it needs to be discounted, like any reward in a return, by γ^k, which is just what the falling eligibility trace achieves. If λ = 1 and γ = 1, then the eligibility traces do not decay at all with time. In this case the method behaves like a Monte Carlo method for an undiscounted, episodic task. If λ = 1, the algorithm is also known as TD(1).

TD(1) is a way of implementing Monte Carlo algorithms that is more general than those presented earlier and that significantly increases their range of applicability. Whereas the earlier Monte Carlo methods were limited to episodic tasks, TD(1) can be applied to discounted continuing tasks as well. Moreover, TD(1) can be performed incrementally and online. One disadvantage of Monte Carlo methods is that they learn nothing from an episode until it is over. For example, if a Monte Carlo control method takes an action that produces a very poor reward but does not end the episode, then the agent’s tendency to repeat the action will be undiminished during the episode. Online TD(1), on the other hand, learns in an n-step TD way from the incomplete ongoing episode, where the n steps are all the way up to the current step. If something unusually good or bad happens during an episode, control methods based on TD(1) can learn immediately and alter their behavior on that same episode.

It is revealing to revisit the 19-state random walk example (Example 7.1) to see how well TD(λ) does in approximating the off-line λ-return algorithm. The results for both algorithms are shown in Figure 12.6. For each λ value, if α is selected optimally for it (or smaller), then the two algorithms perform virtually identically. If α is chosen larger than is optimal, however, then the λ-return algorithm is only a little worse whereas TD(λ) is much worse and may even be unstable. This is not catastrophic for TD(λ) on this problem, as these higher parameter values are not what one would want to use anyway, but for other problems it can be a significant weakness.

<!-- PDF 317 | 书 295 -->
[[FIG: 12.6]]
**Figure 12.6:** 19-state Random walk results (Example 7.1): Performance of TD(λ) alongside that of the off-line λ-return algorithm. The two algorithms performed virtually identically at low (less than optimal) α values, but TD(λ) was worse at high α values.

Linear TD(λ) has been proved to converge in the on-policy case if the step-size parameter is reduced over time according to the usual conditions (2.7). Just as discussed in Section 9.4, convergence is not to the minimum-error weight vector, but to a nearby weight vector that depends on λ. The bound on solution quality presented in that section (9.14) can now be generalized to apply for any λ. For the continuing discounted case,

[[EQ: (12.8)]]

That is, the asymptotic error is no more than (1−γλ)/(1−γ) times the smallest possible error. As λ approaches 1, the bound approaches the minimum error (and it is loosest at λ = 0). In practice, however, λ = 1 is often the poorest choice, as will be illustrated later in Figure 12.14.

*Exercise 12.3* Some insight into how TD(λ) can closely approximate the off-line λ-return algorithm can be gained by seeing that the latter’s error term (in brackets in (12.4)) can be written as the sum of TD errors (12.6) for a single fixed w. Show this, following the pattern of (6.6), and using the recursive relationship for the λ-return you obtained in Exercise 12.1. <!-- 无星 -->

*Exercise 12.4* Use your result from the preceding exercise to show that, if the weight updates over an episode were computed on each step but not actually used to change the weights (w remained fixed), then the sum of TD(λ)’s weight updates would be the same as the sum of the off-line λ-return algorithm’s updates. <!-- 无星 -->

## 12.3 n-step Truncated λ-return Methods

The off-line λ-return algorithm is an important ideal, but it is of limited utility because it uses the λ-return (12.2), which is not known until the end of the episode. In the

<!-- PDF 318 | 书 296 -->
continuing case, the λ-return is technically never known, as it depends on n-step returns for arbitrarily large n, and thus on rewards arbitrarily far in the future. However, the dependence becomes weaker for longer-delayed rewards, falling by γλ for each step of delay. A natural approximation, then, would be to truncate the sequence after some number of steps. Our existing notion of n-step returns provides a natural way to do this in which the missing rewards are replaced with estimated values.

In general, we define the *truncated λ-return* for time t, given data only up to some later horizon, h, as

[[EQ: (12.9)]]

If you compare this equation with the λ-return (12.3), it is clear that the horizon h is playing the same role as was previously played by T, the time of termination. Whereas in the λ-return there is a residual weight given to the conventional return G_t, here it is given to the longest available n-step return, G_{t:h} (Figure 12.2).

The truncated λ-return immediately gives rise to a family of n-step λ-return algorithms similar to the n-step methods of Chapter 7. In all of these algorithms, updates are delayed by n steps and only take into account the first n rewards, but now all the k-step returns are included for 1 ≤ k ≤ n (whereas the earlier n-step algorithms used only the n-step return), weighted geometrically as in Figure 12.2. In the state-value case, this family of algorithms is known as Truncated TD(λ), or TTD(λ). The compound backup diagram, shown in Figure 12.7, is similar to that for TD(λ) (Figure 12.1) except that the longest component update is at most n steps rather than always going all the way to the

[[FIG: 12.7]]
**Figure 12.7:** The backup diagram for Truncated TD(λ).

<!-- PDF 319 | 书 297 -->
end of the episode. TTD(λ) is defined by (cf. (9.15)):

[[EQ: (unnumbered p319-1)]]

This algorithm can be implemented efficiently so that per-step computation does not scale with n (though of course memory must). Much as in n-step TD methods, no updates are made on the first n − 1 time steps of each episode, and n − 1 additional updates are made upon termination. Efficient implementation relies on the fact that the k-step λ-return can be written exactly as

[[EQ: (12.10)]]

where

[[EQ: (unnumbered p319-2)]]

*Exercise 12.5* Several times in this book (often in exercises) we have established that returns can be written as sums of TD errors if the value function is held constant. Why is (12.10) another instance of this? Prove (12.10). <!-- 无星 -->

## 12.4 Redoing Updates: Online λ-return Algorithm

Choosing the truncation parameter n in Truncated TD(λ) involves a tradeoff. n should be large so that the method closely approximates the off-line λ-return algorithm, but it should also be small so that the updates can be made sooner and can influence behavior sooner. Can we get the best of both? Well, yes, in principle we can, albeit at the cost of computational complexity.

The idea is that, on each time step as you gather a new increment of data, you go back and redo all the updates since the beginning of the current episode. The new updates will be better than the ones you previously made because now they can take into account the time step’s new data. That is, the updates are always towards an n-step truncated λ-return target, but they always use the latest horizon. In each pass over that episode you can use a slightly longer horizon and obtain slightly better results. Recall that the truncated λ-return is defined in (12.9) as

[[EQ: (unnumbered p319-3)]]

Let us step through how this target could ideally be used if computational complexity was not an issue. The episode begins with an estimate at time 0 using the weights **w**_0 from the end of the previous episode. Learning begins when the data horizon is extended to time step 1. The target for the estimate at step 0, given the data up to horizon 1, could only be the one-step return G_{0:1}, which includes R_1 and bootstraps from the estimate v̂(S_1, **w**_0). Note that this is exactly what G^λ_{0:1} is, with the sum in the first term of the

<!-- PDF 320 | 书 298 -->
equation degenerating to zero. Using this update target, we construct **w**_1. Then, after advancing the data horizon to step 2, what do we do? We have new data in the form of R_2 and S_2, as well as the new **w**_1, so now we can construct a better update target G^λ_{0:2} for the first update from S_0 as well as a better update target G^λ_{1:2} for the second update from S_1. Using these improved targets, we redo the updates at S_1 and S_2, starting again from **w**_0, to produce **w**_2. Now we advance the horizon to step 3 and repeat, going all the way back to produce three new targets, redoing all updates starting from the original **w**_0 to produce **w**_3, and so on. Each time the horizon is advanced, all the updates are redone starting from **w**_0 using the weight vector from the preceding horizon.

This conceptual algorithm involves multiple passes over the episode, one at each horizon, each generating a different sequence of weight vectors. To describe it clearly we have to distinguish between the weight vectors computed at the different horizons. Let us use **w**_t^h to denote the weights used to generate the value at time t in the sequence up to horizon h. The first weight vector **w**_0^h in each sequence is that inherited from the previous episode (so they are the same for all h), and the last weight vector **w**_h^h in each sequence defines the ultimate weight-vector sequence of the algorithm. At the final horizon h = T we obtain the final weights **w**_T^T which will be passed on to form the initial weights of the next episode. With these conventions, the three first sequences described in the previous paragraph can be given explicitly:

[[EQ: (unnumbered p320-1)]]

[[EQ: (unnumbered p320-2)]]

[[EQ: (unnumbered p320-3)]]

The general form for the update is

[[EQ: (unnumbered p320-4)]]

This update, together with **w**_t ≐ **w**_t^t defines the *online λ-return algorithm*.

The online λ-return algorithm is fully online, determining a new weight vector **w**_t at each step t during an episode, using only information available at time t. Its main drawback is that it is computationally complex, passing over the portion of the episode experienced so far on every step. Note that it is strictly more complex than the off-line λ-return algorithm, which passes through all the steps at the time of termination but does not make any updates during the episode. In return, the online algorithm can be expected to perform better than the off-line one, not only during the episode when it makes an update while the off-line algorithm makes none, but also at the end of the episode because the weight vector used in bootstrapping (in G^λ_{t:h}) has had a larger number of informative

<!-- PDF 321 | 书 299 -->
updates. This effect can be seen if one looks carefully at Figure 12.8, which compares the two algorithms on the 19-state random walk task.

[[FIG: 12.8]]
**Figure 12.8:** 19-state Random walk results (Example 7.1): Performance of online and off-line λ-return algorithms. The performance measure here is the V̄Ē at the end of the episode, which should be the best case for the off-line algorithm. Nevertheless, the online algorithm performs subtly better. For comparison, the λ=0 line is the same for both methods.

## 12.5 True Online TD(λ)

The online λ-return algorithm just presented is currently the best performing temporal-difference algorithm. It is an ideal which online TD(λ) only approximates. As presented, however, the online λ-return algorithm is very complex. Is there a way to invert this forward-view algorithm to produce an efficient backward-view algorithm using eligibility traces? It turns out that there is indeed an exact computationally congenial implementation of the online λ-return algorithm for the case of linear function approximation. This implementation is known as the true online TD(λ) algorithm because it is “truer” to the ideal of the online λ-return algorithm than the TD(λ) algorithm is.

The derivation of true online TD(λ) is a little too complex to present here (see the next section and the appendix to the paper by van Seijen et al., 2016) but its strategy is simple. The sequence of weight vectors produced by the online λ-return algorithm can be arranged in a triangle:

[[EQ: (unnumbered p321-1)]]

One row of this triangle is produced on each time step. It turns out that the weight vectors on the diagonal, the **w**_t^t, are the only ones really needed. The first, **w**_0^0, is the initial weight

<!-- PDF 322 | 书 300 -->
vector of the episode, the last, **w**_T^T, is the final weight vector, and each weight vector along the way, **w**_t^t, plays a role in bootstrapping in the n-step returns of the updates. In the final algorithm the diagonal weight vectors are renamed without a superscript, **w**_t ≐ **w**_t^t. The strategy then is to find a compact, efficient way of computing each **w**_t^t from the one before. If this is done, for the linear case in which v̂(s, **w**) = **w**^⊤**x**(s), then we arrive at the true online TD(λ) algorithm:

[[EQ: (unnumbered p322-1)]]

where we have used the shorthand **x**_t ≐ **x**(S_t), δ_t is defined as in TD(λ) (12.6), and **z**_t is defined by

[[EQ: (12.11)]]

This algorithm has been proven to produce exactly the same sequence of weight vectors, **w**_t, 0 ≤ t ≤ T, as the online λ-return algorithm (van Seijen et al. 2016). Thus the results on the random walk task on the left of Figure 12.8 are also its results on that task. Now, however, the algorithm is much less expensive. The memory requirements of true online TD(λ) are identical to those of conventional TD(λ), while the per-step computation is increased by about 50% (there is one more inner product in the eligibility-trace update). Overall, the per-step computational complexity remains of O(d), the same as TD(λ). Pseudocode for the complete algorithm is given in the box.

<!-- BOX 开始：True online TD(λ) for estimating w^⊤x ≈ v_π -->
**True online TD(λ) for estimating w^⊤x ≈ v_π**

```
Input: the policy π to be evaluated
Input: a feature function x : 𝒮⁺ → ℝ^d such that x(terminal, ·) = 0
Algorithm parameters: step size α > 0, trace decay rate λ ∈ [0, 1]
Initialize value-function weights w ∈ ℝ^d (e.g., w = 0)

Loop for each episode:
    Initialize state and obtain initial feature vector x
    z ← 0 (a d-dimensional vector)
    V_old ← 0 (a temporary scalar variable)
    Loop for each step of episode:
        Choose A ∼ π
        Take action A, observe R, x′ (feature vector of the next state)
        V ← w^⊤x
        V′ ← w^⊤x′
        δ ← R + γV′ − V
        z ← γλz + (1 − αγλz^⊤x)x
        w ← w + α(δ + V − V_old)z − α(V − V_old)x
        V_old ← V′
        x ← x′
    until x′ = 0 (signaling arrival at a terminal state)
```
<!-- BOX 结束 -->

The eligibility trace (12.11) used in true online TD(λ) is called a *dutch trace* to distinguish it from the trace (12.5) used in TD(λ), which is called an *accumulating trace*.

<!-- PDF 323 | 书 301 -->
Earlier work often used a third kind of trace called the replacing trace, defined only for the tabular case or for binary feature vectors such as those produced by tile coding. The replacing trace is defined on a component-by-component basis depending on whether the component of the feature vector was 1 or 0:

[[EQ: (12.12)]]

Nowadays, we see replacing traces as crude approximations to dutch traces, which largely supersede them. Dutch traces usually perform better than replacing traces and have a clearer theoretical basis. Accumulating traces remain of interest for nonlinear function approximations where dutch traces are not available.

## 12.6 \*Dutch Traces in Monte Carlo Learning

Although eligibility traces are closely associated historically with TD learning, in fact they have nothing to do with it. In fact, eligibility traces arise even in Monte Carlo learning, as we show in this section. We show that the linear MC algorithm (Chapter 9), taken as a forward view, can be used to derive an equivalent yet computationally cheaper backward-view algorithm using dutch traces. This is the only equivalence of forward- and backward-views that we explicitly demonstrate in this book. It gives some of the flavor of the proof of equivalence of true online TD(λ) and the online λ-return algorithm, but is much simpler.

The linear version of the gradient Monte Carlo prediction algorithm (page 202) makes the following sequence of updates, one for each time step of the episode:

[[EQ: (12.13)]]

To simplify the example, we assume here that the return G is a single reward received at the end of the episode (this is why G is not subscripted by time) and that there is no discounting. In this case the update is also known as the Least Mean Square (LMS) rule. As a Monte Carlo algorithm, all the updates depend on the final reward/return, so none can be made until the end of the episode. The MC algorithm is an off-line algorithm and we do not seek to improve this aspect of it. Rather we seek merely an implementation of this algorithm with computational advantages. We will still update the weight vector only at the end of the episode, but we will do some computation during each step of the episode and less at its end. This will give a more equal distribution of computation—O(d) per step—and also remove the need to store the feature vectors at each step for use later at the end of each episode. Instead, we will introduce an additional vector memory, the eligibility trace, keeping in it a summary of all the feature vectors seen so far. This will be sufficient to efficiently recreate exactly the same overall update as the sequence of MC

<!-- PDF 324 | 书 302 -->
updates (12.13), by the end of the episode:

[[EQ: (12.14)]]
where **F**_t ≐ **I** − α**x**_t**x**_t^⊤ is a *forgetting, or fading,* matrix. Now, recursing,
[[EQ: (12.14) 续]]

where **a**_{T−1} and **z**_{T−1} are the values at time T − 1 of two auxiliary memory vectors that can be updated incrementally without knowledge of G and with O(d) complexity per time step. The **z**_t vector is in fact a dutch-style eligibility trace. It is initialized to **z**_0 = **x**_0 and then updated according to

[[EQ: (unnumbered p324-1)]]

which is the dutch trace for the case of γλ=1 (cf. Eq. 12.11). The **a**_t auxiliary vector is initialized to **a**_0 = **w**_0 and then updated according to

[[EQ: (unnumbered p324-2)]]

<!-- PDF 325 | 书 303 -->
The auxiliary vectors, **a**_t and **z**_t, are updated on each time step t < T and then, at time T when G is observed, they are used in (12.14) to compute **w**_T. In this way we achieve exactly the same final result as the MC/LMS algorithm that has poor computational properties (12.13), but now with an incremental algorithm whose time and memory complexity per step is O(d). This is surprising and intriguing because the notion of an eligibility trace (and the dutch trace in particular) has arisen in a setting without temporal-difference (TD) learning (in contrast to van Seijen and Sutton, 2014). It seems eligibility traces are not specific to TD learning at all; they are more fundamental than that. The need for eligibility traces seems to arise whenever one tries to learn long-term predictions in an efficient manner.

## 12.7 Sarsa(λ)

Very few changes in the ideas already presented in this chapter are required in order to extend eligibility-traces to action-value methods. To learn approximate action values, q̂(s, a, **w**), rather than approximate state values, v̂(s, **w**), we need to use the action-value form of the n-step return, from Chapter 10:

[[EQ: (unnumbered p325-1)]]

with G_{t:t+n} ≐ G_t if t + n ≥ T. Using this, we can form the action-value form of the λ-return, which is otherwise identical to the state-value form (12.3). The action-value form of the off-line λ-return algorithm (12.4) simply uses q̂ rather than v̂:

[[EQ: (12.15)]]

where G_t^λ ≐ G_{t:∞}^λ. The compound backup diagram for this forward view is shown in Figure 12.9. Notice the similarity to the diagram of the TD(λ) algorithm (Figure 12.1). The first update looks ahead one full step, to the next state–action pair, the second looks ahead two steps, to the second state–action pair, and so on. A final update is based on the complete return. The weighting of each n-step update in the λ-return is just as in TD(λ) and the λ-return algorithm (12.3).

The temporal-difference method for action values, known as *Sarsa(λ)*, approximates this forward view. It has the same update rule as given earlier for TD(λ):

[[EQ: (unnumbered p325-2)]]

except, naturally, using the action-value form of the TD error:

[[EQ: (12.16)]]

and the action-value form of the eligibility trace:

[[EQ: (unnumbered p325-3)]]

<!-- PDF 326 | 书 304 -->
[[FIG: 12.9]]
**Figure 12.9:** Sarsa(λ)’s backup diagram. Compare with Figure 12.1.

Complete pseudocode for Sarsa(λ) with linear function approximation, binary features, and either accumulating or replacing traces is given in the box on the next page. This pseudocode highlights a few optimizations possible in the special case of binary features (features are either active (=1) or inactive (=0)).

<!-- 例题开始：Example 12.1: Traces in Gridworld -->
**Example 12.1: Traces in Gridworld** The use of eligibility traces can substantially increase the efficiency of control algorithms over one-step methods and even over n-step methods. The reason for this is illustrated by the gridworld example below.

[[FIG: 12-inline-2]]

The first panel shows the path taken by an agent in a single episode. The initial estimated values were zero, and all rewards were zero except for a positive reward at the goal location marked by G. The arrows in the other panels show, for various algorithms, which action-values would be increased, and by how much, upon reaching the goal. A one-step method would increment only the last action value, whereas an n-step method would equally increment the last n actions’ values (assuming γ = 1), and an eligibility trace method would update all the action values up to the beginning of the episode, to different degrees, fading with recency. The fading strategy is often the best. ■
<!-- 例题结束 -->

<!-- PDF 327 | 书 305 -->
<!-- BOX 开始：Sarsa(λ) with binary features and linear function approximation for estimating w^⊤x ≈ q_π or q_* -->
**Sarsa(λ) with binary features and linear function approximation for estimating w^⊤x ≈ q_π or q_\***

```
Input: a function ℱ(s, a) returning the set of (indices of) active features for s, a
Input: a policy π
Algorithm parameters: step size α > 0, trace decay rate λ ∈ [0, 1], small ε > 0
Initialize: w = (w_1, . . . , w_d)^⊤ ∈ ℝ^d (e.g., w = 0), z = (z_1, . . . , z_d)^⊤ ∈ ℝ^d

Loop for each episode:
    Initialize S
    Choose A ∼ π(·|S) or ε-greedy according to q̂(S, ·, w)
    z ← 0
    Loop for each step of episode:
        Take action A, observe R, S′
        δ ← R
        Loop for i in ℱ(S, A):
            δ ← δ − w_i
            z_i ← z_i + 1 (accumulating traces)
            or z_i ← 1 (replacing traces)
        If S′ is terminal then:
            w ← w + αδz
            Go to next episode
        Choose A′ ∼ π(·|S′) or ε-greedy according to q̂(S′, ·, w)
        Loop for i in ℱ(S′, A′): δ ← δ + γw_i
        w ← w + αδz
        z ← γλz
        S ← S′; A ← A′
```
<!-- BOX 结束 -->

*Exercise 12.6* Modify the pseudocode for Sarsa(λ) to use dutch traces (12.11) without the other distinctive features of a true online algorithm. Assume linear function approximation and binary features. <!-- 无星 -->

<!-- 例题开始：Example 12.2: Sarsa(λ) on Mountain Car -->
**Example 12.2: Sarsa(λ) on Mountain Car** Figure 12.10 (left) on the next page shows results with Sarsa(λ) on the Mountain Car task introduced in Example 10.1. The function approximation, action selection, and environmental details were exactly as in Chapter 10, and thus it is appropriate to numerically compare these results with the Chapter 10 results for n-step Sarsa (right side of the figure). The earlier results varied the update length n whereas here for Sarsa(λ) we vary the trace parameter λ, which plays a similar role. The fading-trace bootstrapping strategy of Sarsa(λ) appears to result in more efficient learning on this problem. ■
<!-- 例题结束 -->

There is also an action-value version of our ideal TD method, the online λ-return algorithm (Section 12.4) and its efficient implementation as true online TD(λ) (Section 12.5). Everything in Section 12.4 goes through without change other than to use the action-value form of the n-step return given at the beginning of the current section. The analyses in Sections 12.5 and 12.6 also carry through for action values, the only change being the use

<!-- PDF 328 | 书 306 -->
[[FIG: 12.10]]
**Figure 12.10:** Early performance on the Mountain Car task of Sarsa(λ) with replacing traces and n-step Sarsa (copied from Figure 10.4) as a function of the step size, α.

of state–action feature vectors x_t = x(S_t, A_t) instead of state feature vectors x_t = x(S_t). Pseudocode for the resulting efficient algorithm, called true online Sarsa(λ) is given in the box on the next page. The figure below compares the performance of various versions of Sarsa(λ) on the Mountain Car example.

[[FIG: 12.11]]
**Figure 12.11:** Summary comparison of Sarsa(λ) algorithms on the Mountain Car task. True online Sarsa(λ) performed better than regular Sarsa(λ) with both accumulating and replacing traces. Also included is a version of Sarsa(λ) with replacing traces in which, on each time step, the traces for the state and the actions not selected were set to zero.

<!-- PDF 329 | 书 307 -->
<!-- BOX 开始：True online Sarsa(λ) for estimating w^⊤x ≈ q_π or q_* -->
**True online Sarsa(λ) for estimating w^⊤x ≈ q_π or q_\***

```
Input: a feature function x : 𝒮⁺ × 𝒜 → ℝ^d such that x(terminal, ·) = 0
Input: a policy π (if estimating q_π)
Algorithm parameters: step size α > 0, trace decay rate λ ∈ [0, 1], small ε > 0
Initialize: w ∈ ℝ^d (e.g., w = 0)

Loop for each episode:
    Initialize S
    Choose A ∼ π(·|S) or ε-greedy according to q̂(S, ·, w)
    x ← x(S, A)
    z ← 0
    Q_old ← 0
    Loop for each step of episode:
        Take action A, observe R, S′
        Choose A′ ∼ π(·|S′) or ε-greedy according to q̂(S′, ·, w)
        x′ ← x(S′, A′)
        Q ← w^⊤x
        Q′ ← w^⊤x′
        δ ← R + γQ′ − Q
        z ← γλz + (1 − αγλz^⊤x)x
        w ← w + α(δ + Q − Q_old)z − α(Q − Q_old)x
        Q_old ← Q′
        x ← x′
        A ← A′
    until S′ is terminal
```
<!-- BOX 结束 -->

Finally, there is also a truncated version of Sarsa(λ), called *forward Sarsa(λ)* (van Seijen, 2016), which appears to be a particularly effective model-free control method for use in conjunction with multi-layer artificial neural networks.

## 12.8 Variable λ and γ

We are starting now to reach the end of our development of fundamental TD learning algorithms. To present the final algorithms in their most general forms, it is useful to generalize the degree of bootstrapping and discounting beyond constant parameters to functions potentially dependent on the state and action. That is, each time step will have a different λ and γ, denoted λ_t and γ_t. We change notation now so that λ : 𝒮 × 𝒜 → [0, 1] is now a function from states and actions to the unit interval such that λ_t ≐ λ(S_t, A_t), and similarly, γ : 𝒮 → [0, 1] is a function from states to the unit interval such that γ_t ≐ γ(S_t).

Introducing the function γ, the *termination function*, is particularly significant because it changes the return, the fundamental random variable whose expectation we seek to

<!-- PDF 330 | 书 308 -->

estimate. Now the return is defined more generally as

[[EQ: (12.17)]]

where, to assure the sums are finite, we require that ∏_{k=t}^∞ γ_k = 0 with probability one for all t. One convenient aspect of this definition is that it enables the episodic setting and its algorithms to be presented in terms of a single stream of experience, without special terminal states, start distributions, or termination times. An erstwhile terminal state becomes a state at which γ(s) = 0 and which transitions to the start distribution. In that way (and by choosing γ(·) as a constant in all other states) we can recover the classical episodic setting as a special case. State dependent termination includes other prediction cases such as *pseudo termination*, in which we seek to predict a quantity without altering the flow of the Markov process. Discounted returns can be thought of as such a quantity, in which case state-dependent termination unifies the episodic and discounted-continuing cases. (The undiscounted-continuing case still needs some special treatment.)

The generalization to variable bootstrapping is not a change in the problem, like discounting, but a change in the solution strategy. The generalization affects the λ-returns for states and actions. The new state-based λ-return can be written recursively as

[[EQ: (12.18)]]

where now we have added the “s” to the superscript λ to remind us that this is a return that bootstraps from state values, distinguishing it from returns that bootstrap from action values, which we present below with “a” in the superscript. This equation says that the λ-return is the first reward, undiscounted and unaffected by bootstrapping, plus possibly a second term to the extent that we are not discounting at the next state (that is, according to γ_{t+1}; recall that this is zero if the next state is terminal). To the extent that we aren’t terminating at the next state, we have a second term which is itself divided into two cases depending on the degree of bootstrapping in the state. To the extent we are bootstrapping, this term is the estimated value at the state, whereas, to the extent that we are not bootstrapping, the term is the λ-return for the next time step. The action-based λ-return is either the Sarsa form

[[EQ: (12.19)]]

or the Expected Sarsa form,

[[EQ: (12.20)]]

where (7.8) is generalized to function approximation as

[[EQ: (12.21)]]

<!-- PDF 331 | 书 309 -->

*Exercise 12.7* Generalize the three recursive equations above to their truncated versions, defining G^λs_{t:h} and G^λa_{t:h}. <!-- 无星 -->

## 12.9 Off-policy Traces with Control Variates

The final step is to incorporate importance sampling. For methods using non-truncated λ-returns, there is not a practical option in which the importance-sampling weighting is applied to the target return (as there is for n-step methods as explained in Section 7.3). Instead, we move directly to the bootstrapping generalization of per-decision importance sampling with control variates (Section 7.4).

In the state case, our final definition of the λ-return generalizes (12.18), after the model of (7.13), to

[[EQ: (12.22)]]

where ρ_t = π(A_t|S_t)/b(A_t|S_t) is the usual single-step importance sampling ratio. Much like the other returns we have seen in this book, this final λ-return can be approximated simply in terms of sums of the state-based TD error,

[[EQ: (12.23)]]

as

[[EQ: (12.24)]]

with the approximation becoming exact if the approximate value function does not change.

*Exercise 12.8* Prove that (12.24) becomes exact if the value function does not change. To save writing, consider the case of t = 0, and use the notation V_k ≐ v̂(S_k, w). <!-- 无星 -->

*Exercise 12.9* The truncated version of the general off-policy return is denoted G^λs_{t:h}. Guess the correct equation, based on (12.24). <!-- 无星 -->

The above form of the λ-return (12.24) is convenient to use in a forward-view update,

[[EQ: (unnumbered p331-1)]]

which to the experienced eye looks like an eligibility-based TD update—the product is like an eligibility trace and it is multiplied by TD errors. But this is just one time step of a forward view. The relationship that we are looking for is that the forward-view update, summed over time, is approximately equal to a backward-view update, summed over time (this relationship is only approximate because again we ignore changes in the value

<!-- PDF 332 | 书 310 -->

function). The sum of the forward-view update over time is

[[EQ: (unnumbered p332-1)]]

which would be in the form of the sum of a backward-view TD update if the entire expression from the second sum on could be written and updated incrementally as an eligibility trace, which we now show can be done. That is, we show that if this expression was the trace at time k, then we could update it from its value at time k − 1 by:

[[EQ: (unnumbered p332-2)]]

which, changing the index from k to t, is the general accumulating trace update for state values:

[[EQ: (12.25)]]

This eligibility trace, together with the usual semi-gradient parameter-update rule for TD(λ) (12.7), forms a general TD(λ) algorithm that can be applied to either on-policy or off-policy data. In the on-policy case, the algorithm is exactly TD(λ) because ρ_t is always 1 and (12.25) becomes the usual accumulating trace (12.5) (extended to variable λ and γ). In the off-policy case, the algorithm often works well but, as a semi-gradient method, is not guaranteed to be stable. In the next few sections we will consider extensions of it that do guarantee stability.

A very similar series of steps can be followed to derive the off-policy eligibility traces for *action-value* methods and corresponding general Sarsa(λ) algorithms. One could start with either recursive form for the general action-based λ-return, (12.19) or (12.20), but the latter (the Expected Sarsa form) works out to be simpler. We extend (12.20) to the

<!-- PDF 333 | 书 311 -->

off-policy case after the model of (7.14) to produce

[[EQ: (12.26)]]

where V̄_t(S_{t+1}) is as given by (12.21). Again the λ-return can be written approximately as the sum of TD errors,

[[EQ: (12.27)]]

using the expectation form of the action-based TD error:

[[EQ: (12.28)]]

As before, the approximation becomes exact if the approximate value function does not change.

*Exercise 12.10* Prove that (12.27) becomes exact if the value function does not change. To save writing, consider the case of t = 0, and use the notation Q_k = q̂(S_k, A_k, w). Hint: Start by writing out δ^a_0 and G^λa_0, then G^λa_0 − Q_0. <!-- 无星 -->

*Exercise 12.11* The truncated version of the general off-policy return is denoted G^λa_{t:h}. Guess the correct equation for it, based on (12.27). <!-- 无星 -->

Using steps entirely analogous to those for the state case, one can write a forward-view update based on (12.27), transform the sum of the updates using the summation rule, and finally derive the following form for the eligibility trace for action values:

[[EQ: (12.29)]]

This eligibility trace, together with the expectation-based TD error (12.28) and the usual semi-gradient parameter-update rule (12.7), forms an elegant, efficient Expected Sarsa(λ) algorithm that can be applied to either on-policy or off-policy data. It is probably the best algorithm of this type at the current time (though of course it is not guaranteed to be stable until combined in some way with one of the methods presented in the following sections). In the on-policy case with constant λ and γ, and the usual state–action TD error (12.16), the algorithm would be identical to the Sarsa(λ) algorithm presented in Section 12.7.

*Exercise 12.12* Show in detail the steps outlined above for deriving (12.29) from (12.27). Start with the update (12.15), substitute G^λa_t from (12.26) for G^λ_t, then follow similar steps as led to (12.25). <!-- 无星 -->

At λ = 1, these algorithms become closely related to corresponding Monte Carlo algorithms. One might expect that an exact equivalence would hold for episodic problems and off-line updating, but in fact the relationship is subtler and slightly weaker than that. Under these most favorable conditions still there is not an episode by episode equivalence of updates, only of their expectations. This should not be surprising as these methods

<!-- PDF 334 | 书 312 -->

make irrevocable updates as a trajectory unfolds, whereas true Monte Carlo methods would make no update for a trajectory if any action within it has zero probability under the target policy. In particular, all of these methods, even at λ = 1, still bootstrap in the sense that their targets depend on the current value estimates—it’s just that the dependence cancels out in expected value. Whether this is a good or bad property in practice is another question. Recently, methods have been proposed that do achieve an exact equivalence (Sutton, Mahmood, Precup and van Hasselt, 2014). These methods require an additional vector of “provisional weights” that keep track of updates which have been made but may need to be retracted (or emphasized) depending on the actions taken later. The state and state–action versions of these methods are called PTD(λ) and PQ(λ) respectively, where the ‘P’ stands for Provisional.

The practical consequences of all these new off-policy methods have not yet been established. Undoubtedly, issues of high variance will arise as they do in all off-policy methods using importance sampling (Section 11.9).

If λ < 1, then all these off-policy algorithms involve bootstrapping and the deadly triad applies (Section 11.3), meaning that they can be guaranteed stable only for the tabular case, for state aggregation, and for other limited forms of function approximation. For linear and more-general forms of function approximation the parameter vector may diverge to infinity as in the examples in Chapter 11. As we discussed there, the challenge of off-policy learning has two parts. Off-policy eligibility traces deal effectively with the first part of the challenge, correcting for the expected value of the targets, but not at all with the second part of the challenge, having to do with the distribution of updates. Algorithmic strategies for meeting the second part of the challenge of off-policy learning with eligibility traces are summarized in Section 12.11.

*Exercise 12.13* What are the dutch-trace and replacing-trace versions of off-policy eligibility traces for state-value and action-value methods? <!-- 无星 -->

## 12.10 Watkins’s Q(λ) to Tree-Backup(λ)

Several methods have been proposed over the years to extend Q-learning to eligibility traces. The original is *Watkins’s Q(λ)*, which decays its eligibility traces in the usual way as long as a greedy action was taken, then cuts the traces to zero after the first non-greedy action. The backup diagram for Watkins’s Q(λ) is shown in Figure 12.12. In Chapter 6, we unified Q-learning and Expected Sarsa in the off-policy version of the latter, which includes Q-learning as a special case, and generalizes it to arbitrary target policies, and in the previous section of this chapter we completed our treatment of Expected Sarsa by generalizing it to off-policy eligibility traces. In Chapter 7, however, we distinguished *n*-step Expected Sarsa from *n*-step Tree Backup, where the latter retained the property of not using importance sampling. It remains then to present the eligibility trace version of Tree Backup, which we will call *Tree-Backup(λ)*, or *TB(λ)* for short. This is arguably the true successor to Q-learning because it retains its appealing absence of importance sampling even though it can be applied to off-policy data.

<!-- PDF 335 | 书 313 -->

[[FIG: 12.12]]

**Figure 12.12:** The backup diagram for Watkins’s Q(λ). The series of component updates ends either with the end of the episode or with the first nongreedy action, whichever comes first.

The concept of TB(λ) is straightforward. As shown in its backup diagram in Figure 12.13, the tree-backup updates of each length (from Section 7.5) are weighted in the usual way dependent on the bootstrapping parameter λ. To get the detailed equations, with the right indices on the general bootstrapping and discounting parameters, it is best to start with a recursive form (12.20) for the λ-return using action values, and then expand the bootstrapping case of the target after the model of (7.16):

[[EQ: (unnumbered p335-1)]]

As per the usual pattern, it can also be written approximately (ignoring changes in the approximate value function) as a sum of TD errors,

[[EQ: (unnumbered p335-2)]]

using the expectation form of the action-based TD error (12.28).

Following the same steps as in the previous section, we arrive at a special eligibility trace update involving the target-policy probabilities of the selected actions,

[[EQ: (unnumbered p335-3)]]

<!-- PDF 336 | 书 314 -->

[[FIG: 12.13]]

**Figure 12.13:** The backup diagram for the λ version of the Tree Backup algorithm.

This, together with the usual parameter-update rule (12.7), defines the TB(λ) algorithm. Like all semi-gradient algorithms, TB(λ) is not guaranteed to be stable when used with off-policy data and with a powerful function approximator. To obtain those assurances, TB(λ) would have to be combined with one of the methods presented in the next section.

*Exercise 12.14* How might Double Expected Sarsa be extended to eligibility traces? <!-- 有星 -->

## 12.11 Stable Off-policy Methods with Traces

Several methods using eligibility traces have been proposed that achieve guarantees of stability under off-policy training, and here we present four of the most important using this book’s standard notation, including general bootstrapping and discounting functions. All are based on either the Gradient-TD or the Emphatic-TD ideas presented in Sections 11.7 and 11.8. All the algorithms assume linear function approximation, though extensions to nonlinear function approximation can also be found in the literature.

*GTD(λ)* is the eligibility-trace algorithm analogous to TDC, the better of the two state-value Gradient-TD prediction algorithms discussed in Section 11.7. Its goal is to learn a parameter **w**_t such that v̂(s, **w**) ≐ **w**_t^⊤**x**(s) ≈ *v_π*(s), even from data that is due to following another policy b. Its update is

[[EQ: (unnumbered p336-1)]]

<!-- PDF 337 | 书 315 -->

with δ^s_t, **z**_t, and ρ_t defined in the usual ways for state values (12.23) (12.25) (11.1), and

[[EQ: (12.30)]]

where, as in Section 11.7, **v** ∈ ℝ^d is a vector of the same dimension as **w**, initialized to **v**_0 = **0**, and β > 0 is a second step-size parameter.

*GQ(λ)* is the Gradient-TD algorithm for action values with eligibility traces. Its goal is to learn a parameter **w**_t such that q̂(s, a, **w**_t) ≐ **w**_t^⊤**x**(s, a) ≈ *q_π*(s, a) from off-policy data. If the target policy is ε-greedy, or otherwise biased toward the greedy policy for q̂, then GQ(λ) can be used as a control algorithm. Its update is

[[EQ: (unnumbered p337-1)]]

where **x̄**_t is the average feature vector for S_t under the target policy,

[[EQ: (unnumbered p337-2)]]

δ^a_t is the expectation form of the TD error, which can be written

[[EQ: (unnumbered p337-3)]]

**z**_t is defined in the usual way for action values (12.29), and the rest is as in GTD(λ), including the update for **v**_t (12.30).

*HTD(λ)* is a hybrid state-value algorithm combining aspects of GTD(λ) and TD(λ). Its most appealing feature is that it is a strict generalization of TD(λ) to off-policy learning, meaning that if the behavior policy happens to be the same as the target policy, then HTD(λ) becomes the same as TD(λ), which is not true for GTD(λ). This is appealing because TD(λ) is often faster than GTD(λ) when both algorithms converge, and TD(λ) requires setting only a single step size. HTD(λ) is defined by

[[EQ: (unnumbered p337-4)]]

where β > 0 again is a second step-size parameter. In addition to the second set of weights, **v**_t, HTD(λ) also has a second set of eligibility traces, **z**^b_t. These are conventional accumulating eligibility traces for the behavior policy and become equal to **z**_t if all the ρ_t are 1, which causes the last term in the **w**_t update to be zero and the overall update to reduce to TD(λ).

*Emphatic TD(λ)* is the extension of the one-step Emphatic-TD algorithm (Sections 9.11 and 11.8) to eligibility traces. The resultant algorithm retains strong off-policy convergence guarantees while enabling any degree of bootstrapping, albeit at the cost of

<!-- PDF 338 | 书 316 -->

high variance and potentially slow convergence. Emphatic TD(λ) is defined by

[[EQ: (unnumbered p338-1)]]

where M_t ≥ 0 is the general form of *emphasis*, F_t ≥ 0 is termed the *followon trace*, and I_t ≥ 0 is the *interest*, as described in Section 11.8. Note that M_t, like δ_t, is not really an additional memory variable. It can be removed from the algorithm by substituting its definition into the eligibility-trace equation. Pseudocode and software for the true online version of Emphatic-TD(λ) are available on the web (Sutton, 2015b).

In the on-policy case (ρ_t = 1, for all t), Emphatic-TD(λ) is similar to conventional TD(λ), but still significantly different. In fact, whereas Emphatic-TD(λ) is guaranteed to converge for all state-dependent λ functions, TD(λ) is not. TD(λ) is guaranteed convergent only for all constant λ. See Yu’s counterexample (Ghiassian, Rafiee, and Sutton, 2016).

## 12.12 Implementation Issues

It might at first appear that tabular methods using eligibility traces are much more complex than one-step methods. A naive implementation would require every state (or state–action pair) to update both its value estimate and its eligibility trace on every time step. This would not be a problem for implementations on single-instruction, multiple-data, parallel computers or in plausible artificial neural network (ANN) implementations, but it is a problem for implementations on conventional serial computers. Fortunately, for typical values of λ and γ the eligibility traces of almost all states are almost always nearly zero; only those states that have recently been visited will have traces significantly greater than zero and only these few states need to be updated to closely approximate these algorithms.

In practice, then, implementations on conventional computers may keep track of and update only the few traces that are significantly greater than zero. Using this trick, the computational expense of using traces in tabular methods is typically just a few times that of a one-step method. The exact multiple of course depends on λ and γ and on the expense of the other computations. Note that the tabular case is in some sense the worst case for the computational complexity of eligibility traces. When function approximation is used, the computational advantages of not using traces generally decrease. For example, if ANNs and backpropagation are used, then eligibility traces generally cause only a doubling of the required memory and computation per step. Truncated λ-return methods (Section 12.3) can be computationally efficient on conventional computers though they always require some additional memory.

<!-- PDF 339 | 书 317 -->

## 12.13 Conclusions

Eligibility traces in conjunction with TD errors provide an efficient, incremental way of shifting and choosing between Monte Carlo and TD methods. The *n*-step methods of Chapter 7 also enabled this, but eligibility trace methods are more general, often faster to learn, and offer different computational complexity tradeoffs. This chapter has offered an introduction to the elegant, emerging theoretical understanding of eligibility traces for on- and off-policy learning and for variable bootstrapping and discounting. One aspect of this elegant theory is true online methods, which exactly reproduce the behavior of expensive ideal methods while retaining the computational congeniality of conventional TD methods. Another aspect is the possibility of derivations that automatically convert from intuitive forward-view methods to more efficient incremental backward-view algorithms. We illustrated this general idea in a derivation that started with a classical, expensive Monte Carlo algorithm and ended with a cheap incremental non-TD implementation using the same novel eligibility trace used in true online TD methods.

As we mentioned in Chapter 5, Monte Carlo methods may have advantages in non-Markov tasks because they do not bootstrap. Because eligibility traces make TD methods more like Monte Carlo methods, they also can have advantages in these cases. If one wants to use TD methods because of their other advantages, but the task is at least partially non-Markov, then the use of an eligibility trace method is indicated. Eligibility traces are the first line of defense against both long-delayed rewards and non-Markov tasks.

By adjusting λ, we can place eligibility trace methods anywhere along a continuum from Monte Carlo to one-step TD methods. Where shall we place them? We do not yet have a good theoretical answer to this question, but a clear empirical answer appears to be emerging. On tasks with many steps per episode, or many steps within the half-life of discounting, it appears significantly better to use eligibility traces than not to (e.g., see Figure 12.14). On the other hand, if the traces are so long as to produce a pure Monte Carlo method, or nearly so, then performance degrades sharply. An intermediate mixture appears to be the best choice. Eligibility traces should be used to bring us toward Monte Carlo methods, but not all the way there. In the future it may be possible to more finely vary the trade-off between TD and Monte Carlo methods by using variable λ, but at present it is not clear how this can be done reliably and usefully.

Methods using eligibility traces require more computation than one-step methods, but in return they offer significantly faster learning, particularly when rewards are delayed by many steps. Thus it often makes sense to use eligibility traces when data are scarce and cannot be repeatedly processed, as is often the case in online applications. On the other hand, in off-line applications in which data can be generated cheaply, perhaps from an inexpensive simulation, then it often does not pay to use eligibility traces. In these cases the objective is not to get more out of a limited amount of data, but simply to process as much data as possible as quickly as possible. In these cases the speedup per datum due to traces is typically not worth their computational cost, and one-step methods are favored.

<!-- PDF 340 | 书 318 -->

[[FIG: 12.14]]

**Figure 12.14:** The effect of λ on reinforcement learning performance in four different test problems. In all cases, performance is generally best (a *lower* number in the graph) at an intermediate value of λ. The two left panels are applications to simple continuous-state control tasks using the Sarsa(λ) algorithm and tile coding, with either replacing or accumulating traces (Sutton, 1996). The upper-right panel is for policy evaluation on a random walk task using TD(λ) (Singh and Sutton, 1996). The lower right panel is unpublished data for the pole-balancing task (Example 3.4) from an earlier study (Sutton, 1984).

<!-- PDF 341 | 书 319 -->

## Bibliographical and Historical Remarks

Eligibility traces came into reinforcement learning via the fecund ideas of Klopf (1972). Our use of eligibility traces is based on Klopf’s work (Sutton, 1978a, 1978b, 1978c; Barto and Sutton, 1981a, 1981b; Sutton and Barto, 1981a; Barto, Sutton, and Anderson, 1983; Sutton, 1984). We may have been the first to use the term “eligibility trace” (Sutton and Barto, 1981a). The idea that stimuli produce after effects in the nervous system that are important for learning is very old (see Chapter 14). Some of the earliest uses of eligibility traces were in the actor–critic methods discussed in Chapter 13 (Barto, Sutton, and Anderson, 1983; Sutton, 1984).

**12.1** Compound updates were called “complex backups” in the first edition of this book.

The λ-return and its error-reduction properties were introduced by Watkins (1989) and further developed by Jaakkola, Jordan, and Singh (1994). The random walk results in this and subsequent sections are new to this text, as are the terms “forward view” and “backward view.” The notion of a λ-return algorithm was introduced in the first edition of this text. The more refined treatment presented here was developed in conjunction with Harm van Seijen (e.g., van Seijen and Sutton, 2014).

**12.2** TD(λ) with accumulating traces was introduced by Sutton (1988, 1984). Convergence in the mean was proved by Dayan (1992), and with probability 1 by many researchers, including Peng (1993), Dayan and Sejnowski (1994), Tsitsiklis (1994), and Gurvits, Lin, and Hanson (1994). The bound on the error of the asymptotic λ-dependent solution of linear TD(λ) is due to Tsitsiklis and Van Roy (1997).

**12.3** Truncated TD methods were developed by Cichosz (1995) and van Seijen (2016).

**12.4** The idea of redoing updates was extensively developed by van Seijen, originally under the name “best-match learning” (van Seijen, 2011; van Seijen, Whiteson, van Hasselt, and Weiring, 2011).

**12.5** True online TD(λ) is primarily due to Harm van Seijen (van Seijen and Sutton, 2014; van Seijen et al., 2016) though some of its key ideas were discovered independently by Hado van Hasselt (personal communication). The name “dutch traces” is in recognition of the contributions of both scientists. Replacing traces are due to Singh and Sutton (1996).

**12.6** The material in this section is from van Hasselt and Sutton (2015).

**12.7** Sarsa(λ) with accumulating traces was first explored as a control method by Rummery and Niranjan (1994; Rummery, 1995). True Online Sarsa(λ) was

<!-- PDF 342 | 书 320 -->

introduced by van Seijen and Sutton (2014). The algorithm on page 307 was adapted from van Seijen et al. (2016). The Mountain Car results were made for this text, except for Figure 12.11 which is adapted from van Seijen and Sutton (2014).

**12.8** Perhaps the first published discussion of variable λ was by Watkins (1989), who pointed out that the cutting off of the update sequence (Figure 12.12) in his Q(λ) when a nongreedy action was selected could be implemented by temporarily setting λ to 0.

Variable λ was introduced in the first edition of this text. The roots of variable γ are in the work on options (Sutton, Precup, and Singh, 1999) and its precursors (Sutton, 1995a), becoming explicit in the GQ(λ) paper (Maei and Sutton, 2010), which also introduced some of these recursive forms for the λ-returns.

A different notion of variable λ has been developed by Yu (2012).

**12.9** Off-policy eligibility traces were introduced by Precup et al. (2000, 2001), then further developed by Bertsekas and Yu (2009), Maei (2011; Maei and Sutton, 2010), Yu (2012), and by Sutton, Mahmood, Precup, and van Hasselt (2014). The last reference in particular gives a powerful forward view for off-policy TD methods with general state-dependent λ and γ. The presentation here seems to be new.

This section ends with an elegant Expected Sarsa(λ) algorithm. Although it is a natural algorithm, to our knowledge it has not previously been described or tested in the literature.

**12.10** Watkins’s Q(λ) is due to Watkins (1989). The tabular, episodic, off-line version has been proven convergent by Munos, Stepleton, Harutyunyan, and Bellemare (2016). Alternative Q(λ) algorithms were proposed by Peng and Williams (1994, 1996) and by Sutton, Mahmood, Precup, and van Hasselt (2014). Tree Backup(λ) is due to Precup, Sutton, and Singh (2000).

**12.11** GTD(λ) is due to Maei (2011). GQ(λ) is due to Maei and Sutton (2010). HTD(λ) is due to White and White (2016) based on the one-step HTD algorithm introduced by Hackman (2012). The latest developments in the theory of Gradient-TD methods are by Yu (2017). Emphatic TD(λ) was introduced by Sutton, Mahmood, and White (2016), who proved its stability. Yu (2015, 2016) proved its convergence, and the algorithm was developed further by Hallak et al. (2015, 2016).
