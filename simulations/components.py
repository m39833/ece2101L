from typing import TYPE_CHECKING, TypeAlias

from PySpice.Spice.Netlist import Circuit, DeviceModel, Node
from PySpice.Unit import u_us, u_V
from PySpice.Unit.Unit import UnitValue, UnitValues

if TYPE_CHECKING:
    UnitValueType: TypeAlias = UnitValue[int] | UnitValue[float] | UnitValue[complex]
else:
    UnitValueType = UnitValue

SpiceValue: TypeAlias = str | int | float | complex | UnitValueType | UnitValues


def add_timed_spdt(
    circuit: Circuit,
    name: str,
    common_node: str | Node,
    before_node: str | Node,
    after_node: str | Node,
    time_to_switch: SpiceValue,
    sim_duration: int | float,
) -> None:
    ctl_node = f"{name}_ctl"
    high_model = f"{name}_HIGH"
    low_model = f"{name}_LOW"

    circuit.PulseVoltageSource(
        f"{name}_control",
        ctl_node,
        circuit.gnd,
        delay_time=time_to_switch,
        initial_value=5 @ u_V,
        pulsed_value=0 @ u_V,
        rise_time=1 @ u_us,
        fall_time=1 @ u_us,
        pulse_width=sim_duration * 2,
        period=sim_duration * 4,
    )

    circuit.model(
        high_model,
        "SW",
        ron=1e-3,
        roff=1e9,
        vt=2.5,
        vh=0.1,
    )

    circuit.model(
        low_model,
        "SW",
        ron=1e-3,
        roff=1e9,
        vt=-2.5,
        vh=0.1,
    )

    circuit.S(
        f"{name}_before",
        common_node,
        before_node,
        ctl_node,
        circuit.gnd,
        model=high_model,
    )

    circuit.S(
        f"{name}_after",
        common_node,
        after_node,
        circuit.gnd,
        ctl_node,
        model=low_model,
    )


def mk_ideal_switch(
    circuit: Circuit,
    time_to_switch: SpiceValue,
    sim_duration: UnitValue[int] | UnitValue[float],
    ctl_name: str = "ctl",
) -> tuple[DeviceModel, DeviceModel]:
    circuit.PulseVoltageSource(
        ctl_name,
        ctl_name,
        circuit.gnd,
        delay_time=time_to_switch,
        initial_value=5 @ u_V,
        pulsed_value=0 @ u_V,
        rise_time=1 @ u_us,
        fall_time=1 @ u_us,
        pulse_width=sim_duration * 2,
        period=sim_duration * 4,
    )

    hi = circuit.model("SW_HIGH", "SW", ron=1e-3, roff=1e9, vt=2.5, vh=0.1)
    lo = circuit.model("SW_LOW", "SW", ron=1e-3, roff=1e9, vt=-2.5, vh=0.1)

    return (hi, lo)
