# Nyx
## Project Vision

Nyx is a modular, declarative NixOS configuration project designed to evolve into a reusable framework for managing Linux systems.

The project currently serves as my personal NixOS configuration and development environment. Its architecture is being developed with broader adoption in mind, allowing users to compose systems from reusable modules, select functionality according to their requirements, and maintain distinct configurations for different machines.

The long-term objective is to provide a flexible foundation that others can adapt without having to adopt my personal system configuration or maintain an entirely separate configuration architecture.

Nyx is under active development. Its current implementation is deployed on my personal laptop, while broader host support, portability, and general-purpose configuration interfaces remain ongoing work.

## Design goals

- **Declarative configuration:** Describe system and user configuration in version-controlled Nix files.
- **Modularity:** Keep related functionality in focused modules rather than a single large host configuration.
- **Reuse:** Share common definitions across machines while retaining host-specific settings.
- **Explicit composition:** Make it possible to understand which modules and settings contribute to a given host.
- **Maintainability:** Favor configurations that can be inspected, changed, and rebuilt from the command line.

These are design goals, not guarantees that every configuration or planned host is complete.

## Architecture

The repository's `flake.nix` defines a shared `mkSystem` helper around `nixpkgs.lib.nixosSystem`. It creates NixOS outputs for named hosts and includes the Home Manager NixOS module. Each host points to its own configuration under `identity/`.

`agg.nix` collects modules from the major functional directories, including base system services, boot and filesystem configuration, graphical environment options, features, and a user profile. Individual modules and host configuration determine which settings are applied.

The intended composition model is:

1. **Modules** define specific capabilities or configuration areas.
2. **Bundles and profiles** organize related capabilities and user settings.
3. **Hosts** compose those definitions with machine-specific requirements.

The repository is still evolving, and not every planned bundle or module is fully implemented.

### Repository layout

```text
Nyx/
├── flake.nix       # Flake inputs, shared system builder, host outputs
├── flake.lock      # Locked flake dependencies
├── agg.nix         # Shared module import aggregation
├── base/           # Base operating-system services and settings
├── boot/           # Boot and filesystem-related configuration
├── device/         # Device-specific configuration
├── features/       # Optional functionality
├── gui/            # Desktop, window-manager, and lock-screen settings
├── identity/       # Host definitions and host-specific settings
└── user/           # User profiles and dotfile-related configuration
```

### Defined hosts

| Host | Intended role | Status |
| --- | --- | --- |
| **Nomad** | Personal laptop | In use |
| **Citadel** | Compute server | Planned / not deployed |
| **Bulwark** | Desktop | Planned / not deployed |
| **Sentinel** | Network video recorder | Planned / not deployed |

The existence of a flake output does not mean its corresponding host has been built or deployed.

## Technologies

- **NixOS and Nix flakes** for declarative system configuration and dependency pinning.
- **Home Manager** for managing user-level configuration alongside NixOS.
- **Git** for tracking configuration changes.
- **Nix modules and custom options** for organizing and selecting configuration.

## Usage and prerequisites

Nyx is primarily maintained for my own machines. It is not currently a turnkey configuration for unrelated hardware.

A prospective user would need a compatible NixOS installation, an understanding of the relevant hardware configuration, and to review host-specific settings, users, paths, and external dependencies before attempting deployment.

The flake currently includes a local path input (`ik_llama` at `/com/ik_llama.cpp-main`). That dependency is machine-specific and can prevent evaluation on a different system unless it is made available or the flake is adjusted.

For reference, a NixOS flake configuration is normally selected by host name:

```sh
sudo nixos-rebuild switch --flake .#Nomad
```

**This is an illustrative command, not a verified installation procedure.** Do not run it on an existing system without first reviewing the host configuration and confirming that all inputs resolve. I have not independently validated a clean installation from this repository.

## Current status and limitations

- **Deployed:** Nomad, my personal NixOS laptop configuration.
- **Defined but not deployed:** Citadel, Bulwark, and Sentinel.
- **In development:** Broader reuse of modules, host-specific composition, and future infrastructure configurations.
- **Not yet established:** A reproducible, documented installation path for arbitrary machines or a validated multi-host deployment.
- **Portability limitation:** At least one flake input references an absolute local filesystem path.

Some modules and storage configurations are placeholders or works in progress. Their presence in the repository should not be interpreted as evidence that those capabilities have been deployed.

## Development approach

Nyx is developed iteratively on a system I use. I favor terminal-based administration, direct inspection of configuration, and small changes that can be reviewed in Git. The architecture is intended to grow with my requirements while keeping the relationships between hosts, modules, and user configuration understandable.

## Roadmap

- Continue refining the working Nomad configuration.
- Improve module boundaries and host-independent configuration.
- Reduce machine-specific dependencies that complicate evaluation elsewhere.
- Expand host definitions as desktop and server systems are actually deployed.
- Document tested build, validation, and recovery procedures.

## Scope

This repository documents a personal configuration and an evolving infrastructure design. It may be useful as a reference, but it is not presented as a tested, supported installer for other systems.
