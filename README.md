# Fabric Mod Template

## Setup

To rename this template to your project name, run:

```bash
./scripts/rename.sh <new-project-name>
```

Example:
```bash
./scripts/rename.sh my-cool-mod
```

On some systems you may need sudo:
```bash
sudo ./scripts/rename.sh my-cool-mod
```

This will:
- Rename the package from `ua.borukva.mod_template` to `ua.borukva.<new_name>`
- Update `MOD_ID` in `ModInit.java`
- Update `archives_base_name` in `gradle.properties`
- Update `fabric.mod.json` (id, entrypoints, assets path, mixin reference)
- Rename `template-mod.mixins.json` to `<new-name>.mixins.json`
- Rename assets directory
- Remove git remote origin
- Clear this README
- Delete the scripts directory
- Rename the root directory

Note: Root directory renaming may fail on some systems (e.g., WSL). If it does, rename it manually:
```bash
mv mod-template <new-project-name>
```
