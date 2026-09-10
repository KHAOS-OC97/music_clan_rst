# Feature-Based Modular Architecture

This workspace reorganizes the supplied RST/HOC-style Roblox UI payload into a feature-based modular structure.

## Folder layout

```text
src/
  Services.lua      -> Roblox services and local player access
  Config.lua        -> global configuration/state defaults
  Bootstrap.lua     -> environment setup and UI cleanup hooks
  Notifications.lua -> temporary toast notification system
  Hud.lua           -> HUD screen creation and UI shell
  Transmission.lua -> chat/transmission message generation and loop
  Roster.lua        -> roster/search and multi-target selection
  Main.lua          -> feature bootstrapping and entry point
```

## Purpose

Each module owns a single area of responsibility. The main entry point only starts the platform and loads feature modules instead of containing all logic in one monolithic script.
