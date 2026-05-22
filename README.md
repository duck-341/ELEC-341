## ELEC 341 Helper Functions

A collection of MATLAB helper functions for ELEC 341 (Prof. Leo Stocco). Some parts of the code were written with help from ChatGPT and Gemini. My friends and I tested these functions on many sample problems, but feel free to revise or improve them. Below are some functions that I used a lot, also an example is provided.

### 1. step_help

Used for step response questions where you are asked for:
- Rise time
- Peak time
- Settling time
- Modified rise time
- Effective tau
- Percent overshoot

also approxiamtion:
- First-order
- Second-order overdamped
- Second-order underdamped

Usage:

```matlab
info = step_help(figNum, cal)
```

- `figNum`: figure index
- `cal`: switch for enabling approximation

Notes:
- Only works for smooth step responses.
- Metrics are automatically annotated on the graph.
- Results are returned in the `info` structure.
- The function reads xlabel for unit, ideal case: time(s) or time(ms). As long as it has s/ms and some other string.

### 2. get_opt_zero

Used for controller design questions where partial dynamics (PI/PD) are given and you need to find the ONE zero that gives the maximum phase margin.

Usage:

```matlab
info = get_opt_zero(wxo, Gol_partial)
```

- `wxo`: crossover frequency of the partial dynamics (can be obtained using `margin`)
- `Gol_partial`: open-loop transfer function combined with the partial dynamics (G_open * D_partial)

Notes:
- The zero should be negative.
- Results are returned in the `info` structure.

### 3. get_opt_sec_zero

Used for controller design questions where partial dynamics (PID) are given and you need to find the TWO zeros that give the maximum phase margin.

Usage:

```matlab
info = get_opt_sec_zero(Gol_partial, wxo, zeta_step, wn_step)
```

- `Gol_partial`: open-loop transfer function combined with the partial dynamics
- `wxo`: crossover frequency of the partial dynamics (can be obtained using `margin`)
- `zeta_step`: search resolution for damping factor $\zeta$
- `wn_step`: search resolution for natural frequency $w_n$

Notes:
- This function may take some time to run.
- Using a finer search resolution than required is recommended (e.g. $\times 10$).
- Results are returned in the `info` structure.

### 4. pid_heuristic_gui

GUI tool for heuristic PID tuning, usually useful for the last question on the final exam.

Usage:

```matlab
pid_heuristic_gui(DP, G, H, K_master0, Kp_n0, Ki_n0, Kd_n0)
```

- `DP`: controller transfer function
- `G`: forward-path transfer function
- `H`: sensor/backward-path transfer function

The transfer function names should match those used in the system diagram. The four gain values are only starting values. What I usually do is:
- K_master0 = 1
- Use values from previous questions for the other three gains.

Notes:

You can define a structure called `standard` in the workspace for reference targets, for example:

```matlab
standard.Ts = 0.8 * Q14.Ts;
standard.OSu = 0.5 * Q14.OSu;
```

Supported fields include, and you don't need to fullfill every field, only name the ones required:

```matlab
Tr, Tp, Ts, OSu, OSy, Ess
```

(case insensitive)

After tuning, you can export the result. All exported values are stored in the structure `pid_export`. The correct answer of heuristic tuning is based on your own result for the previous question so you don't have to be too worried.



## GOOD LUCK!
