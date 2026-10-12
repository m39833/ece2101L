from math import pi

import matplotlib.pyplot as plt
import numpy as np
from PySpice.Spice.Netlist import Circuit
from PySpice.Unit import u_F, u_H, u_V, u_Ω

from simulations.constants import ANNOTATION_BLUE

from ..utils import mkfigpath

FREQUENCY = 1000
omega = 2 * pi * FREQUENCY

circuit = Circuit("part 2")
circuit.SinusoidalVoltageSource(
    "test",
    "input",
    circuit.gnd,
    dc_offset=0 @ u_V,
    ac_magnitude=1 @ u_V,
)

circuit.R("input", "input", "a", 2 @ u_Ω)

circuit.L("shunt", "a", "b", (2 / omega) @ u_H)
circuit.R("shunt", "b", circuit.gnd, 2 @ u_Ω)

circuit.C("series", "a", "c", (1 / (4 * omega)) @ u_F)
circuit.R("right", "c", "d", 4 @ u_Ω)
circuit.L("right", "d", circuit.gnd, (6 / omega) @ u_H)

sim = circuit.simulator()
ac = sim.ac(
    variation="lin",
    number_of_points=1,
    start_frequency=FREQUENCY,
    stop_frequency=FREQUENCY,
)

voltage = complex(np.asarray(ac.nodes["input"]).item())
current = -complex(np.asarray(ac.branches["vtest"]).item())
z_simulated = voltage / current
z_calculated = 44 / 13 + 1j * 14 / 13

assert np.isclose(z_simulated, z_calculated, atol=1e-6)

fig = plt.figure(figsize=(7, 4), constrained_layout=True)
ax = fig.add_subplot()
positions = np.arange(2)
width = 0.35
ax.bar(
    positions - width / 2,
    (z_calculated.real, z_calculated.imag),
    width,
    label="calculated",
)
ax.bar(
    positions + width / 2,
    (z_simulated.real, z_simulated.imag),
    width,
    label="simulated",
    color=ANNOTATION_BLUE,
)
ax.set_title(r"Calculated vs. simulated $Z_T$")
ax.set_xticks(positions, (r"$\Re\{Z_T\}$", r"$\Im\{Z_T\}$"))
ax.set_ylabel("impedance (Ω)")
ax.grid(axis="y", alpha=0.4)
ax.legend()

fig.savefig(mkfigpath(__file__), dpi=600)
plt.show()
