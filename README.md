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

- Document names must use **camelCase** for each section, separated by underscores.
- Use meaningful, searchable descriptions.*

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


---

# Git Workflow

## Branching Policy

**DO NOT make changes directly to the `main` branch.**

The `main` branch should always remain in a deployable, stable state. All development work must be performed in a separate branch and reviewed before being merged.

### Standard Workflow (GitHub Desktop)

1. **Pull the latest changes**
   - Open GitHub Desktop.
   - Ensure you are on the `main` branch.
   - Select **Fetch origin** and then **Pull origin** if updates are available.

2. **Create a new branch**
   - Select **Current Branch** -> **New Branch**.
   - Name the branch according to the work being performed.

   **Examples:**
   ```
   feature_updateCompressorData
   fix_pressureCalculation
   docs_namingConventionUpdate
   ```

3. **Switch to the new branch**
   - Verify the new branch is selected before making any changes.

4. **Make your changes**
   - Edit project files as needed.
   - Save your work.

5. **Commit your changes**
   - In GitHub Desktop, review the changed files.
   - Enter a short, descriptive commit message.
   - **DO NOT COMMIT LARGE DATA FILES**

   **Examples:**
   ```
   Add compressor efficiency calculations
   Fix pressure ratio equation
   Update naming convention documentation
   ```

6. **Push the branch**
   - Select **Push origin** to upload your branch to GitHub.
   - If you have not fishished work still push to your branch to save your work online. This lets you continue from another computer.

7. **Create a Pull Request**
   - Only submit a Pill Request (PR) when you are done with work on your branch 
   - Select **Create Pull Request** in GitHub Desktop (or on GitHub).
   - Provide a brief description of the changes.
   - Request a review so changes can be merged. One reviewer is required to merge to main.

8. **Wait for Approval**
   - Merge the Pull Request into `main` only after it has been reviewed and approved by one other member. The approver may merge for you.
   - Resolve any comments that my prevent merge.

9. **Update your local repository**
   - After the Pull Request is merged:
     - Switch back to the `main` branch.
     - Pull the latest changes.
     - Delete the completed feature branch if it is no longer needed.


## Updating your branch
- If there are changes to the main branch while you are working on your own branch you can pull the changes to your branch by clicking `Ctrl + Shift + U` or by going to `Branch` -> `Update from Main`.

## Branch Naming Convention

- Use lowercase prefixes followed by a descriptive camelCase name.
- You can name based off the task you are making or any other name you see fit. Potential examples below.

| Type | Format | Example |
|------|--------|---------|
| New Feature | `feature_description` | `feature_addPerformanceCharts` |
| Bug Fix | `fix_description` | `fix_pressureCalculation` |
| Documentation | `docs_description` | `docs_updateNamingGuide` |
| Refactor | `refactor_description` | `refactor_fileStructure` |

## Commit Message Guidelines

- Keep commit messages short and descriptive.
- Break commits up, dont sumbit one megacommit. Check which files go together in a comit and describe the work you did.

### Good Examples

```
Add turbine performance report
Fix compressor efficiency calculation
Update project documentation
Refactor folder organization
```

### Avoid

```
Stuff
Update
Changes
Fix
asdf
```

## Important Rules

- Never commit directly to the `main` branch.
- Always create a new branch before making changes.
- Pull the latest changes before creating a branch.
- Keep Pull Requests focused on a single task whenever possible.
- Write clear commit messages so project history remains easy to understand.
- Delete completed branches after they have been merged.