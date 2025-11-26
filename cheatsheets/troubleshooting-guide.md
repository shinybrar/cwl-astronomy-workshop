# CWL Troubleshooting Guide

## Quick Diagnosis Checklist

Before diving deep, check these common issues:

- [ ] Is your virtual environment activated? (`which python` should show venv path)
- [ ] Is Docker running? (`docker info`)
- [ ] Is cwltool installed? (`cwltool --version`)
- [ ] Does the CWL file validate? (`cwltool --validate file.cwl`)
- [ ] Do all input files exist? (check paths in job file)
- [ ] Are file paths absolute or correct relative paths?

---

## Virtual Environment Issues

#### "cwltool: command not found" (but you installed it)
```
bash: cwltool: command not found
```

**Solution**: Your virtual environment isn't activated:
```bash
source cwl-workshop-env/bin/activate  # Linux/macOS
# or
cwl-workshop-env\Scripts\activate  # Windows
```

#### "ModuleNotFoundError" when running cwltool
**Solution**: Install in the correct environment:
```bash
# Make sure you're in your venv
which python  # Should show path to venv
pip install cwltool
```

---

## Error Categories

### 1. Validation Errors

#### "Missing required input"
```
Error: Missing required input parameter 'input_file'
```

**Solution**: Add the missing parameter to your job file:
```yaml
input_file:
  class: File
  path: /path/to/file.txt
```

#### "Invalid type"
```
Error: Expected type 'File', got 'string'
```

**Solution**: Wrap file paths in proper File object:
```yaml
# Wrong
input_file: /path/to/file.txt

# Correct
input_file:
  class: File
  path: /path/to/file.txt
```

#### "Unknown field"
```
Error: 'unknownField' is not a valid field
```

**Solution**: Check spelling and CWL version compatibility. Common typos:
- `inputBinding` not `input_binding`
- `baseCommand` not `base_command`
- `outputBinding` not `output_binding`

---

### 2. Docker Errors

#### "Docker daemon not running"
```
Error: Cannot connect to the Docker daemon
```

**Solutions**:
1. Start Docker Desktop
2. On Linux: `sudo systemctl start docker`
3. Test: `docker run hello-world`

#### "Image not found"
```
Error: pull access denied for image:tag
```

**Solutions**:
1. Check image name spelling
2. Pull manually: `docker pull image:tag`
3. Check if image requires authentication

#### "Permission denied in container"
```
Error: Permission denied: '/output/file.txt'
```

**Solutions**:
1. Check file permissions before running
2. Container may run as different user
3. Try `--user $(id -u):$(id -g)` with cwltool

#### "Out of memory"
```
Error: Killed (OOM)
```

**Solutions**:
1. Increase Docker memory limit (Docker Desktop → Settings)
2. Add ResourceRequirement to your CWL:
```yaml
requirements:
  ResourceRequirement:
    ramMin: 8000  # MB
```

---

### 3. File/Path Errors

#### "File not found"
```
Error: [Errno 2] No such file or directory
```

**Solutions**:
1. Use absolute paths in job files
2. Check current working directory
3. Verify file actually exists: `ls -la /path/to/file`

#### "Output not captured"
```
Final output is empty or missing expected files
```

**Solutions**:
1. Check glob pattern matches actual output filename:
```yaml
outputs:
  result:
    type: File
    outputBinding:
      glob: "*.txt"  # Make sure this matches
```
2. Run tool manually to see what files are created
3. Add `stdout: output.log` to capture output

#### "Relative path issues"
**Solution**: Convert to absolute paths in job file:
```yaml
# Use $(pwd) or full path
input_file:
  class: File
  path: /home/user/data/input.fits
```

---

### 4. Workflow Errors

#### "Step output not connected"
```
Error: source 'step_name/wrong_output' not found
```

**Solution**: Verify output names match exactly:
```yaml
steps:
  my_step:
    run: tool.cwl
    out: [correct_output_name]  # Check this name

outputs:
  final:
    outputSource: my_step/correct_output_name  # Must match
```

#### "Circular dependency"
```
Error: Circular dependency detected
```

**Solution**: Reorganize workflow - a step cannot depend on its own output. Draw the data flow diagram to find the cycle.

#### "Scatter mismatch"
```
Error: scatter and scatterMethod required
```

**Solution**: Add ScatterFeatureRequirement:
```yaml
requirements:
  ScatterFeatureRequirement: {}

steps:
  process:
    scatter: input_file
    # ...
```

---

### 5. JavaScript Expression Errors

#### "Expression evaluation failed"
```
Error: Expression evaluation failed
```

**Solutions**:
1. Add InlineJavascriptRequirement:
```yaml
requirements:
  InlineJavascriptRequirement: {}
```

2. Check JavaScript syntax:
```yaml
# Wrong - missing $()
glob: inputs.name + ".txt"

# Correct
glob: $(inputs.name + ".txt")
```

3. Debug by simplifying the expression

---

## Debugging Techniques

### 1. Verbose Output
```bash
cwltool --debug workflow.cwl job.yml 2>&1 | tee debug.log
```

### 2. Keep Temporary Files
```bash
cwltool --leave-tmpdir workflow.cwl job.yml
# Check /tmp/tmpXXXXX directories
```

### 3. Validate Before Running
```bash
cwltool --validate workflow.cwl
```

### 4. Test Individual Tools
Before running the full workflow, test each tool:
```bash
cwltool tool1.cwl tool1-test.yml
cwltool tool2.cwl tool2-test.yml
```

### 5. Run Without Container
```bash
cwltool --no-container workflow.cwl job.yml
```

### 6. Check What Command Would Run
```bash
cwltool --print-rdf workflow.cwl
```

---

## Common Patterns & Fixes

### Capturing stdout
```yaml
baseCommand: echo
stdout: output.txt

outputs:
  message:
    type: stdout  # Captures stdout automatically
```

### Handling Optional Outputs
```yaml
outputs:
  optional_file:
    type: File?
    outputBinding:
      glob: "maybe_exists.txt"
```

### Secondary Files (e.g., .bai index)
```yaml
inputs:
  bam_file:
    type: File
    secondaryFiles:
      - .bai
```

### Environment Variables
```yaml
requirements:
  EnvVarRequirement:
    envDef:
      HOME: /tmp
      PATH: /usr/local/bin:/usr/bin
```

---

## Getting Help

1. **CWL Discourse**: https://cwl.discourse.group/
2. **CWL Gitter**: https://gitter.im/common-workflow-language/common-workflow-language
3. **GitHub Issues**: https://github.com/common-workflow-language/cwltool/issues
4. **Workshop Slack**: #cwl-workshop

---

## Quick Fixes Summary

| Problem | Quick Fix |
|---------|-----------|
| cwltool not found | Activate venv: `source cwl-workshop-env/bin/activate` |
| Docker not running | Start Docker Desktop |
| File not found | Use absolute paths |
| Output missing | Check glob pattern |
| Validation failed | Run `cwltool --validate` |
| Memory issues | Increase Docker RAM limit |
| Permission denied | Check container user |
| Expression failed | Add InlineJavascriptRequirement |
| Scatter not working | Add ScatterFeatureRequirement |
