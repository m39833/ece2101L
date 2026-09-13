from pathlib import Path

SIMULATIONS_DIR = Path(__file__).resolve().parent
FIGURES_DIR = SIMULATIONS_DIR / "figures"


def mkfigpath(source_file: str | Path, suffix: str = ".png") -> Path:
    source = Path(source_file).resolve()
    relative = source.relative_to(SIMULATIONS_DIR).with_suffix(suffix)

    path = FIGURES_DIR / relative
    path.parent.mkdir(parents=True, exist_ok=True)

    print(f"saved figure to {path}")

    return path
