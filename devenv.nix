{
  pkgs,
  multiverse,
  lib,
  config,
  inputs,
  ...
}: let
  libngspice = multiverse.libngspice."34";
in {
  packages = [libngspice];

  languages.typst.enable = true;
  languages.python = {
    enable = true;
    venv.enable = true;
    uv = {
      enable = true;
      sync.enable = true;
    };
  };

  scripts.run = {
    description = "Run a simulation lab part";

    exec = ''
      set -euo pipefail

      usage() {
        echo "Usage: run <lab>-<part>"
        echo "       run <lab>_<part>"
        echo "       run <lab> <part>"
        exit 2
      }

      case "$#" in
        1)
          value="$(printf '%s' "$1" | tr '_' '-')"
          extra=""
          IFS=- read -r lab part extra <<< "$value"

          [ -n "$lab" ] && [ -n "$part" ] && [ -z "$extra" ] || usage
          ;;
        2)
          lab="$1"
          part="$2"
          ;;
        *)
          usage
          ;;
      esac

      [[ "$lab" =~ ^[0-9]+$ ]] || usage
      [[ "$part" =~ ^[0-9]+$ ]] || usage

      printf -v lab  '%02d' "$((10#$lab))"
      printf -v part '%02d' "$((10#$part))"

      module="simulations.lab_$lab.part_$part"

      echo "+ uv run -m $module"
      exec uv run -m "$module"
    '';
  };
}
