# Predict OEIS with DTMC and Chinese Remainder Theorem

# 中国剩余定理内容

中国剩余定理是一个数论的定理。它指出，如果知道某个整数$x$除以若干互素的整数$\{p_i\}$的余数，则可以唯一确定$x$除以这些整数的乘积$n$的余数。在抽象代数中，用同余方式表示的中国剩余定理在所有主理想整环(principal ideal domain, PID)上都成立。若使用一个关于理想的表述，它可以推广到任何交换环上。实际上，整数环$\bf Z$是一个主理想整环，因此整数情况下的中国剩余定理是PID上的中国剩余定理的一个特例。中国剩余定理广泛用于计算大整数，因为它允许在知道计算结果的大小上的界限的情况下，通过小整数上的几个类似的计算来替代大整数的计算。

在抽象代数中的中国剩余定理如下：

**定理1** 设$R$是交换环，$I_1, ..., I_n$为环$R$的两两互素的理想，则同构映射

$$
a(\mathrm{mod}\ I_1I_2...I_n)\mapsto(a(\mathrm{mod}\ I_1), ..., a(\mathrm{mod}\ I_n))
$$

定义了环同构
$$
R/(I_1\cap ...\cap I_n)\cong \prod_{i=1}^n (R/I_i)
$$

在整数环上，从该定理可以得到

**定理2** 设$m_1, ..., m_n$是两两互素的正整数，则有环同构

$$
f:Z/m_1...m_n \cong Z/m_1\times ... \times Z/m_n
$$

用同余的语言表述，则为

**定理3** 设$m_1, ..., m_n$是两两互素的正整数，则对于任意$n$个整数$a_1, ..., a_n\in \bf Z$，同余方程组

$$
\begin{aligned}
x &\equiv a_1 \pmod{m_1} \\
&\ ...\\
x &\equiv a_n \pmod{m_n} 
\end{aligned}
$$

存在整数解，且满足

$$
x\equiv \sum_{i=1}^n (a_ik_i\prod_{j\neq i} m_j) \pmod{m_1...m_n}
$$

的整数$x$为其解集，其中

$$
\begin{aligned}
k_1\prod_{j\neq 1} m_j &\equiv 1 \pmod{m_1} \\
&\ ...\\
k_n\prod_{j\neq n} m_j &\equiv 1 \pmod{m_n}
\end{aligned}
$$

