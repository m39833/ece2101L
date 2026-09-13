import matplotlib.pyplot as plt
import numpy as np
from PySpice.Spice.Netlist import Circuit
from PySpice.Unit import u_A, u_H, u_ms, u_us, u_V, u_Ω

circuit = Circuit("Switched RL circuit")

circuit.I("source", circuit.gnd, "source_node", 6.4 @ u_A)
circuit.R("o", 1, circuit.gnd, 10 @ u_Ω)
circuit.L("", 2, circuit.gnd, 0.32 @ u_H)
circuit.R("1", 1, 2, 6 @ u_Ω)
circuit.R("2", 2, circuit.gnd, 4 @ u_Ω)

# cut source at n ms
t_switch = 20 @ u_ms

circuit.PulseVoltageSource(
    "control",
    "control",
    circuit.gnd,
    initial_value=5 @ u_V,
    pulsed_value=0 @ u_V,
    delay_time=t_switch,
    rise_time=1 @ u_us,
    fall_time=1 @ u_us,
    pulse_width=500 @ u_ms,
    period=1000 @ u_ms,
)
circuit.model(
    "SW_HIGH",
    "SW",
    vt=2.5,
    vh=0.1,
)
circuit.model(
    "SW_LOW",
    "SW",
    vt=-2.5,
    vh=0.1,
)

# short to circuit
circuit.S(
    "source_connect",
    "source_node",
    1,
    "control",
    circuit.gnd,
    model="SW_HIGH",
)

# short to ground
circuit.S(
    "source_dump",
    "source_node",
    circuit.gnd,
    circuit.gnd,
    "control",
    model="SW_LOW",
)

simulator = circuit.simulator()
transient = simulator.transient(
    step_time=0.1 @ u_ms,
    end_time=500 @ u_ms,
)
time_s = np.asarray(transient.time)
i_L = np.asarray(transient.branches["l"])

t_switch_s = float(t_switch)
after_switch_mask = time_s >= t_switch_s
times_after = time_s[after_switch_mask]
currents_after = time_s[after_switch_mask]
t = times_after - t_switch_s

i_0 = np.interp(t_switch_s, times_after, currents_after)

# target_time = 0e-3
# i_probe = np.interp(target_time + t_switch_s, time_s, i_L)
# print(i_probe)
#
# print(np.interp(0.1586 + t_switch_s, time_s, i_L))

dissapated_75 = abs(i_0) * (1 - 0.75)
t_probe = next(
    t for t in list(times_after) if np.interp(t, time_s, i_L) < dissapated_75
)
print(t_probe)

plt.style.use("dark_background")
plt.plot(
    time_s * 1000 - t_switch.value,
    i_L,
    label="Simulated current",
)
plt.scatter(t_probe, i_0)

# i_theoretical = 4 * np.exp(-10 * t)
# plt.plot(
#     time_s[after_switch] * 1000 - t_switch.value,
#     i_theoretical,
#     "--",
#     label=r"Theoretical: $4e^{-10t}$ A",
# )

plt.axvline(
    t_switch_s * 1000 - t_switch.value,
    color="gray",
    linestyle=":",
    label="Switching time",
)

plt.xlabel("Simulation time (ms)")
plt.ylabel("Inductor current (A)")
plt.grid(True)
plt.legend()
plt.tight_layout()
plt.show()
