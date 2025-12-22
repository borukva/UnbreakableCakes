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

This will:
- Rename the package from `ua.borukva.mod_template` to `ua.borukva.<new_name>`
- Update `MOD_ID` in `ModInit.java`
- Update `archives_base_name` in `gradle.properties`
- Update `fabric.mod.json` (id, entrypoints, assets path, mixin reference)
- Rename `template-mod.mixins.json` to `<new-name>.mixins.json`
- Rename assets directory
- Remove git remote origin
- Rename the project root directory
- Clear this README
