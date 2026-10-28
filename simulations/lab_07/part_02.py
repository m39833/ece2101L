import math

import numpy as np
from PySpice.Spice.Netlist import Circuit
from PySpice.Unit import u_F, u_Hz, u_V, u_Ω

pf = 0.7
f = 60.0
R = 100.0

phi = math.acos(pf)
C = 1 / (2 * np.pi * f * R * math.tan(phi))

circuit = Circuit("part 2")

circuit.SinusoidalVoltageSource(
    "s",
    "vin",
    circuit.gnd,
    amplitude=1 @ u_V,
    frequency=f @ u_Hz,
    ac_magnitude=1 @ u_V,
)
circuit.R(1, "vin", "mid", R @ u_Ω)
circuit.C(1, "mid", circuit.gnd, C @ u_F)

sim = circuit.simulator(temperature=25, nominal_temperature=25)
ac = sim.ac(
    variation="lin",
    number_of_points=1,
    start_frequency=f @ u_Hz,
    stop_frequency=f @ u_Hz,
)

V = complex(np.asarray(ac.nodes["vin"]).item())
I = -complex(np.asarray(ac.branches["vs"]).item())
Z = V / I

power_factor = Z.real / abs(Z)
current_lead = np.angle(I / V, deg=True)  # arg(I) - arg(V)

print(f"C = {C * 1e6:.3f} uF")
print(f"Z = {Z.real:.3f} - j{Z.imag:+.3f} ohm")
print(f"Power factor = {power_factor:.4f}")
print(f"Current leads voltage by {current_lead:.2f} degrees")
