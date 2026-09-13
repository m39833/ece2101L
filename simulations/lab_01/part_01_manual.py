import matplotlib.pyplot as plt
import numpy as np
import PySpice.Logging.Logging as Logging
from PySpice.Spice.Netlist import Circuit
from PySpice.Unit import u_A, u_H, u_Ω

from ..utils import mkfigpath

logger = Logging.setup_logging()

before = Circuit("t = 0^-")
before.I("", before.gnd, 1, 6.4 @ u_A)
before.R("o", 1, before.gnd, 10 @ u_Ω)
before.R("1", 1, before.gnd, 6 @ u_Ω)

simulator = before.simulator()
analysis = simulator.operating_point()
nv_1 = analysis["1"]
i_L0_waveform = nv_1 / (6 @ u_Ω)
i_L0 = float(i_L0_waveform.item())

print(f"v_L(0^-) = {float(nv_1.item()):.3f} V", f"i_L(0^-) = {i_L0:.3f} A", sep="\n")

after = Circuit("t >= 0")
after.R("o", 1, after.gnd, 10 @ u_Ω)
after.L("", 2, after.gnd, 0.32 @ u_H, initial_condition=(i_L0 @ u_A))
after.R("1", 1, 2, 6 @ u_Ω)
after.R("2", 2, after.gnd, 4 @ u_Ω)

simulator = after.simulator(temperature=25, nominal_temperature=25)
transient = simulator.transient(
    step_time=1e-4,
    end_time=1,
    use_initial_condition=True,
)


time_ms = np.asarray(transient.time) * 1000
i_inductor = np.asarray(transient.branches["l"])
v_o = np.asarray(transient.nodes["1"])
print(v_o)

# t = np.linspace(0, 500, 100)
# y = -8 * np.exp(-10 * (t / 1000))
# plt.plot(t, y, label="v_o theo")

# plt.style.use("dark_background")
#
# plt.plot(time_ms, i_inductor, label="Inductor current")
# plt.xlabel("Time (ms)")
# plt.ylabel("Current (A)")
# plt.title("Inductor Current vs. Time")
#
plt.plot(time_ms, v_o, label="$v_o(t)$", color="#04ACF3")
plt.xlabel("$t$ (ms)")
plt.ylabel("$v_o$ (V)")
plt.title("$v_o$ vs. $t$")

plt.grid(True)
plt.legend()
plt.tight_layout()

figpath = mkfigpath("01-1")
plt.savefig(mkfigpath(__file__))
print(f"saved figure to {figpath}")

plt.show()
