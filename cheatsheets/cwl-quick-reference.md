# CWL Quick Reference Card

## Essential Structure

### CommandLineTool
```yaml
cwlVersion: v1.2
class: CommandLineTool
baseCommand: [program, subcommand]
inputs:
  input_name:
    type: string
    inputBinding:
      position: 1
outputs:
  output_name:
    type: File
    outputBinding:
      glob: "*.txt"
```

### Workflow
```yaml
cwlVersion: v1.2
class: Workflow
inputs:
  workflow_input:
    type: File
outputs:
  workflow_output:
    type: File
    outputSource: step_name/output_name
steps:
  step_name:
    run: tool.cwl
    in:
      tool_input: workflow_input
    out: [output_name]
```

## Data Types

| Type | Description | Example |
|------|-------------|---------|
| `string` | Text value | `"hello"` |
| `int` | Integer | `42` |
| `float` | Decimal number | `3.14` |
| `boolean` | True/false | `true` |
| `File` | Single file | `class: File` |
| `Directory` | Folder | `class: Directory` |
| `File[]` | Array of files | Multiple files |
| `string[]` | Array of strings | `["a", "b"]` |
| `null` | No value | `null` |
| `Any` | Any type | Flexible |

## Optional and Default Values

```yaml
inputs:
  # Required input
  required_input:
    type: string
  
  # Optional input (can be null)
  optional_input:
    type: string?
  
  # Input with default
  with_default:
    type: string
    default: "default_value"
  
  # Optional with default
  optional_with_default:
    type: string?
    default: "fallback"
```

## Input Binding Options

```yaml
inputs:
  # Positional argument
  positional:
    type: string
    inputBinding:
      position: 1
  
  # Named flag
  named_flag:
    type: string
    inputBinding:
      prefix: --name
  
  # Boolean flag (only adds if true)
  verbose:
    type: boolean
    inputBinding:
      prefix: -v
  
  # Separate prefix and value
  separate:
    type: string
    inputBinding:
      prefix: --config=
      separate: false
```

## Output Binding

```yaml
outputs:
  # Glob pattern
  by_pattern:
    type: File
    outputBinding:
      glob: "*.fits"
  
  # Stdout capture
  stdout_output:
    type: stdout
  
  # Stderr capture
  stderr_output:
    type: stderr
  
  # Multiple files
  all_images:
    type: File[]
    outputBinding:
      glob: "*.png"
```

## Common Requirements

```yaml
requirements:
  # Docker container
  DockerRequirement:
    dockerPull: image:tag
  
  # Embedded files
  InitialWorkDirRequirement:
    listing:
      - entryname: script.py
        entry: |
          #!/usr/bin/env python3
          print("Hello")
  
  # JavaScript expressions
  InlineJavascriptRequirement: {}
  
  # Scatter operations
  ScatterFeatureRequirement: {}
  
  # Subworkflows
  SubworkflowFeatureRequirement: {}
  
  # Resource requests
  ResourceRequirement:
    coresMin: 4
    ramMin: 8000  # MB
```

## Scatter (Parallel Processing)

```yaml
requirements:
  ScatterFeatureRequirement: {}

steps:
  process_many:
    run: tool.cwl
    scatter: input_file
    in:
      input_file: file_array
    out: [output]
```

## JavaScript Expressions

```yaml
requirements:
  InlineJavascriptRequirement: {}

inputs:
  input_file:
    type: File

outputs:
  renamed:
    type: File
    outputBinding:
      glob: $(inputs.input_file.nameroot + "_processed.txt")
```

## Job File Format

```yaml
# String input
message: "Hello"

# Number inputs
count: 42
ratio: 0.75

# Boolean
verbose: true

# File input
input_file:
  class: File
  path: /path/to/file.txt

# Directory input
input_dir:
  class: Directory
  path: /path/to/directory

# Array of files
input_files:
  - class: File
    path: file1.txt
  - class: File
    path: file2.txt
```

## Running Workflows

```bash
# Basic execution
cwltool workflow.cwl job.yml

# With Docker
cwltool --docker workflow.cwl job.yml

# Without Docker (--no-container)
cwltool --no-container workflow.cwl job.yml

# Specify output directory
cwltool --outdir results/ workflow.cwl job.yml

# Verbose output
cwltool --debug workflow.cwl job.yml

# Validate only (don't run)
cwltool --validate workflow.cwl
```

## Debugging Tips

1. **Validate first**: `cwltool --validate workflow.cwl`
2. **Check Docker**: `docker run hello-world`
3. **Inspect temp files**: Look in `/tmp/` during execution
4. **Add debug output**: Use `cwltool --debug`
5. **Test tools individually** before combining into workflows

## Common Errors

| Error | Solution |
|-------|----------|
| `Missing input` | Check job file has all required inputs |
| `File not found` | Use absolute paths or check relative paths |
| `Docker not found` | Install Docker or use `--no-container` |
| `Output not captured` | Check glob pattern matches actual output |
| `Permission denied` | Check file permissions in container |

## Useful Links

- [CWL Specification](https://www.commonwl.org/specification/)
- [CWL User Guide](https://www.commonwl.org/user_guide/)
- [cwltool Documentation](https://github.com/common-workflow-language/cwltool)
