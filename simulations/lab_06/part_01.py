from typing import Dict, cast

import matplotlib.pyplot as plt
import numpy as np
from matplotlib.axes import Axes
from matplotlib.projections.polar import PolarAxes
from matplotlib.ticker import MultipleLocator
from PySpice.Spice.BasicElement import CurrentControlledCurrentSource
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
    u_S,
    u_uF,
    u_uH,
    u_us,
    u_V,
    u_Ω,
)

from ..utils import draw_phasors, mkfigpath

f0 = 1000  # ref freq
omega0 = 2 * np.pi * f0
period = 1 / f0
SIM_DURATION = 5 * period * 1000

circuit = Circuit("part 1")

L_j2 = 2 / omega0  #       Z_L = j𝜔L   =  j2 => L = 2/𝜔
C_j5 = 1 / (5 * omega0)  # Z_C = 1/j𝜔C = -j5 => C = 1/5𝜔

circuit.SinusoidalVoltageSource(
    "",
    circuit.gnd,
    "a",
    dc_offset=0 @ u_V,
    ac_magnitude=33.8 @ u_V,
)

circuit.R("1", "a", "b", 1 @ u_Ω)
circuit.L("", "b", "c", L_j2 @ u_H, initial_condition=0)

circuit.R("2", "c", "d", 3 @ u_Ω)
circuit.C("", "d", circuit.gnd, C_j5 @ u_F, initial_condition=0)

circuit.R("3", "c", circuit.gnd, 2 @ u_Ω)

circuit.VCCS(
    "dep",
    circuit.gnd,
    "c",
    "d",
    circuit.gnd,
    0.75,
)

sim = circuit.simulator()
ac = sim.ac(
    variation="lin",
    number_of_points=1,
    start_frequency=f0,
    stop_frequency=f0,
)

time_s = np.linspace(0, 3 * period, 1000)
vs = -complex(np.asarray(ac.nodes["a"]).item())
vx = complex(np.asarray(ac.nodes["d"]).item())
i = -complex(np.asarray(ac.branches["v"]).item())

print(f"I = {i:.3f} A")
print(f"I = {abs(i):.3f} ∠ {np.angle(i, deg=True):.3f}° A")

vs_phasor = 33.8 + 0j
vs_t = np.real(vs_phasor * np.exp(1j * omega0 * time_s))
vx_t = np.real(vx * np.exp(1j * omega0 * time_s))
i_t = np.real(i * np.exp(1j * omega0 * time_s))

fig = plt.figure(
    figsize=(11, 5.5),
    constrained_layout=True,
)

grid = fig.add_gridspec(
    nrows=1,
    ncols=2,
    width_ratios=(1, 1.15),
)

ax_current = fig.add_subplot(grid[0, 0])
ax_phasor = cast(
    PolarAxes,
    fig.add_subplot(grid[0, 1], projection="polar"),
)

time_ms = time_s * 1000

ax_current.plot(
    time_ms,
    i_t,
    color="#04ACF3",
    label=r"$i(t)$",
)

# ax_current.set_title("Current")
ax_current.set_xlabel(r"$t$ (ms)")
ax_current.set_ylabel("current (A)")
ax_current.grid(alpha=0.4)
ax_current.legend()

draw_phasors(
    {
        # "V_s": vs,
        # "V_x": vx,
        "I": i,
    },
    ax=ax_phasor,
    unit="A",
    thetamin=0,
    thetamax=90,
    grid_step=15,
    color="#04ACF3",
)

fig.suptitle("Current ($i(t)$)", fontsize=16)

# fig.savefig(
#     "circuit_results.png",
#     dpi=200,
#     bbox_inches="tight",
# )


fig.savefig(mkfigpath(__file__), dpi=600)

plt.show()
