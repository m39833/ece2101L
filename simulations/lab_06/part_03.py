from cmath import rect
from math import pi, radians

import matplotlib.pyplot as plt
import numpy as np
from PySpice.Spice.Netlist import Circuit
from PySpice.Unit import u_F, u_H, u_V, u_Ω

from simulations.constants import ANNOTATION_BLUE

from ..utils import mkfigpath

FREQUENCY = 1000
omega = 2 * pi * FREQUENCY

circuit = Circuit("part 3")
circuit.SinusoidalVoltageSource(
    "1",
    "input",
    circuit.gnd,
    dc_offset=0 @ u_V,
    ac_magnitude=1 @ u_V,
)

circuit.R("1", "input", circuit.gnd, 3 @ u_Ω)
circuit.R("2", "input", "a", 2 @ u_Ω)

circuit.R("3", "a", "b", 4 @ u_Ω)
circuit.L("1", "a", "b", (3 / omega) @ u_H)
circuit.R("4", circuit.gnd, "b", 5 @ u_Ω)

circuit.C("1", "b", "c", (1 / (3 * omega)) @ u_F)
circuit.L("2", "b", "d", (2 / omega) @ u_H)
circuit.R("5", "d", "c", 4 @ u_Ω)
circuit.C("2", circuit.gnd, "c", (1 / (3 * omega)) @ u_F)  # bottom -j3 Ω

sim = circuit.simulator()
ac = sim.ac(
    variation="lin",
    number_of_points=1,
    start_frequency=FREQUENCY,
    stop_frequency=FREQUENCY,
)

voltage = complex(np.asarray(ac.nodes["input"]).item())
current = -complex(np.asarray(ac.branches["v1"]).item())
z_simulated = voltage / current
z_calculated = rect(2.0258, radians(0.6654))

assert np.isclose(z_simulated, z_calculated, atol=1e-4)

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
    color=ANNOTATION_BLUE,
    label="simulated",
)
ax.set_title(r"Calculated vs. simulated $Z$")
ax.set_xticks(positions, (r"$\Re\{Z\}$", r"$\Im\{Z\}$"))
ax.set_ylabel("impedance (Ω)")
ax.grid(axis="y", alpha=0.4)
ax.legend()

fig.savefig(mkfigpath(__file__), dpi=600)
plt.show()
