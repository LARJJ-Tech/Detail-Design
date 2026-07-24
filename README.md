```
 ___       ________  ________       ___        ___          _________  _______   ________  ___  ___     
|\  \     |\   __  \|\   __  \     |\  \      |\  \        |\___   ___\\  ___ \ |\   ____\|\  \|\  \    
\ \  \    \ \  \|\  \ \  \|\  \    \ \  \     \ \  \       \|___ \  \_\ \   __/|\ \  \___|\ \  \\\  \   
 \ \  \    \ \   __  \ \   _  _\ __ \ \  \  __ \ \  \           \ \  \ \ \  \_|/_\ \  \    \ \   __  \  
  \ \  \____\ \  \ \  \ \  \\  \|\  \\_\  \|\  \\_\  \           \ \  \ \ \  \_|\ \ \  \____\ \  \ \  \ 
   \ \_______\ \__\ \__\ \__\\ _\ \________\ \________\           \ \__\ \ \_______\ \_______\ \__\ \__\
    \|_______|\|__|\|__|\|__|\|__\|________|\|________|            \|__|  \|_______|\|_______|\|__|\|__|
                                                                                                     
```

# Naming Conventions

## General Rules

- Use **camelCase** within each section of a file name and for variable names.
- Use **PascalCase** for folder names.
- Separate sections with an underscore (`_`).
- **DO NOT** use spaces in folder or file names.
- Capital letters are allowed, but **DO NOT** use all caps.
- Keep names short, descriptive, and consistent.
- Avoid special characters such as `@`, `#`, `$`, `%`, `&`, `*`, `(`, `)`, etc.
- Use only letters, numbers, underscores (`_`), and periods (`.`) where appropriate.

## Folder Naming Convention

- Folder names should clearly describe their contents and follow a logical hierarchy.
- Use **PascalCase** for folder names.
- **DO NOT** use spaces in folder names.

### Example:
```
GasTurbine / CompressorAnalysis
```

## Document Naming Convention

Document names must use **camelCase** for each section, separated by underscores.

***NOTE:** Use meaningful, searchable descriptions.*

`component_description`

### Examples:
```
hpc_firstStagePerformance.docx
lpc_efficiencySummary.xlsx
gasTurbine_performanceReport.pdf
```

## Variable Naming Convention

- Use **camelCase** for all variable names.
- Variable names should clearly describe their purpose.
- Avoid abbreviations unless they are widely understood (e.g., `rpm`, `temp`, `id`).
- Do not use spaces or special characters.
- Avoid single-letter variable names except for short loop indices.

### Good Examples

```
massFlowRate
compressorEfficiency
inletTemperature
pressureRatio
stageCount
```

### Bad Examples

```
x
temp1
COMPRESSOR_TEMP
pressure-ratio
mass flow
```

---

# Quick Reference

| Item | Convention | Example |
|------|------------|---------|
| Folder | `PascalCase / PascalCase` | `GasTurbine / CompressorAnalysis` |
| Document | `camelCase_camelCase` | `hpc_firstStagePerformance.docx` |
| Variable | `camelCase` | `compressorEfficiency` |
