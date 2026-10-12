from math import atan2

import matplotlib.pyplot as plt
import numpy as np
from matplotlib.ticker import MultipleLocator
from PySpice.Spice.Netlist import Circuit
from PySpice.Unit import (
    u_A,
    u_F,
    u_H,
    u_Hz,
    u_kΩ,
    u_mA,
    u_mH,
    u_ms,
    u_nF,
    u_uF,
    u_uH,
    u_us,
    u_V,
    u_Ω,
)

from simulations.constants import ANNOTATION_BLUE, LOOSELY_DASHED

from ..utils import mkfigpath

SIM_DURATION = 0.1

circuit = Circuit("part 3")

circuit.B(
    "source",
    circuit.gnd,
    "a",
    current_expression="8*cos(200000*time)",
)
# 𝜔=200,000 => f = 𝜔/2pi = 31831 Hz => T = 31.42 us

circuit.R("1", "a", circuit.gnd, 10 @ u_Ω)

circuit.R("2", "a", "b", 6 @ u_Ω)
circuit.L("", "b", circuit.gnd, 40 @ u_uH)

circuit.C("", "a", circuit.gnd, 1 @ u_uF, initial_condition=32 @ u_V)

sim = circuit.simulator()
tr = sim.transient(0.1 @ u_us, SIM_DURATION @ u_ms, use_initial_condition=True)
t = np.asarray(tr.time)
v = np.asarray(tr.nodes["a"])
i_1 = np.asarray(tr.nodes["a"]) / 10
v_2 = np.asarray(tr.nodes["b"])

phase = atan2(3, 4)  # 36.87°
hand_values = (
    (v, 40 * np.cos(200000 * t - phase), "$v(t)$", "V"),
    (i_1, 4 * np.cos(200000 * t - phase), "$i_1(t)$", "A"),
    (v_2, 32 * np.cos(200000 * t), "$v_2(t)$", "V"),
)
assert all(
    np.allclose(simulated, calculated, atol=0.01)
    for simulated, calculated, *_ in hand_values
)

fig = plt.figure(figsize=(15, 4), constrained_layout=True)
axes = tuple(fig.add_subplot(1, 3, index) for index in range(1, 4))
for ax, (simulated, calculated, title, unit) in zip(axes, hand_values):
    ax.plot(t * 1000, simulated, label="simulated", color=ANNOTATION_BLUE)
    ax.plot(
        t * 1000,
        calculated,
        linestyle=LOOSELY_DASHED,
        label="calculated",
    )
    ax.set_title(title)
    ax.set_xlabel("$t$ (ms)")
    ax.set_ylabel(f"{title} ({unit})")
    ax.grid()
    ax.legend()

fig.savefig(mkfigpath(__file__), dpi=600)
plt.show()
