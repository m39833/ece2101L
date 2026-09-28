import matplotlib.pyplot as plt
import numpy as np
from matplotlib.ticker import MultipleLocator
from PySpice.Spice.Netlist import Circuit
from PySpice.Unit import (
    u_A,
    u_F,
    u_H,
    u_kΩ,
    u_mA,
    u_mH,
    u_ms,
    u_nF,
    u_uF,
    u_us,
    u_V,
    u_Ω,
)

from ..components import add_timed_spdt
from ..utils import mkfigpath

TIME_TO_SWITCH = 500
SIM_DURATION = 3000

circuit = Circuit("part 2")

circuit.V("", "v-top", circuit.gnd, 12 @ u_V)

circuit.PulseVoltageSource(
    "step",
    "a",
    circuit.gnd,
    initial_value=0 @ u_V,
    pulsed_value=12 @ u_V,
    delay_time=0 @ u_ms,
    rise_time=1 @ u_us,
    fall_time=1 @ u_us,
    pulse_width=SIM_DURATION * 2,
    period=SIM_DURATION * 4,
)

circuit.R("", "a", "b", 6 @ u_Ω)
circuit.L("", "b", "c", 1 @ u_H, initial_condition=4 @ u_A)
circuit.C("", "c", circuit.gnd, 0.04 @ u_F, initial_condition=-4 @ u_V)

sim = circuit.simulator()
tr = sim.transient(
    1 @ u_ms, (TIME_TO_SWITCH + SIM_DURATION) @ u_ms, use_initial_condition=True
)
t = np.asarray(tr.time)
v = np.asarray(tr.nodes["c"])

plt.title("$v_C$ vs. $t$")
plt.xlabel("$t$ (ms)")
plt.ylabel("$v_C$ (V)")
plt.gca().yaxis.set_major_locator(MultipleLocator(3))
plt.grid()

plt.plot(t * 1000, v, label="$v_C (t)$", color="#04ACF3")
# plt.plot(
#     t * 1000,
#     12 - 16 * np.exp(-3 * t) * np.cos(4 * t) + 13 * np.exp(-3 * t) * np.sin(4 * t),
# )

plt.legend()
plt.savefig(mkfigpath(__file__))

plt.show()
