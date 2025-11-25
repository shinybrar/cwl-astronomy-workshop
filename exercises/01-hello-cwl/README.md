# Exercise 1: Hello CWL

Your first CWL workflow! In this exercise, you'll learn the basic structure of CWL files and run your first CommandLineTool.

## Learning Objectives

- Understand CWL file structure
- Write a basic CommandLineTool
- Create a job input file
- Execute a workflow with cwltool

## Background

CWL (Common Workflow Language) is a specification for describing analysis workflows and tools in a way that makes them portable and scalable across different software and hardware environments.

### Key Concepts

1. **CommandLineTool**: Wraps a command-line program
2. **Workflow**: Connects multiple tools together
3. **Job file**: Provides input values for a tool/workflow

## Exercise

### Step 1: Examine the CWL Tool

Open `hello.cwl` and examine its structure:

```yaml
cwlVersion: v1.2
class: CommandLineTool

# What program to run
baseCommand: echo

# Input definitions
inputs:
  message:
    type: string
    inputBinding:
      position: 1

# Output definitions
outputs:
  output:
    type: stdout

stdout: hello-output.txt
```

### Step 2: Examine the Job File

Open `hello-job.yml`:

```yaml
message: "Hello, CWL Workshop!"
```

### Step 3: Run the Workflow

```bash
cwltool hello.cwl hello-job.yml
```

You should see output like:
```
INFO [job hello.cwl] /tmp/xxxxx$ echo \
    'Hello, CWL Workshop!' > hello-output.txt
INFO [job hello.cwl] completed success
{
    "output": {
        "location": "file:///path/to/hello-output.txt",
        "basename": "hello-output.txt",
        "class": "File",
        "checksum": "sha1$...",
        "size": 22
    }
}
INFO Final process status is success
```

### Step 4: Verify the Output

Check the output file:
```bash
cat hello-output.txt
```

## Challenge

Modify the workflow to:

1. Accept a `name` input parameter
2. Output "Hello, [name]! Welcome to CWL."

Hints:
- You can use multiple input parameters
- String concatenation happens in the shell

## Key Takeaways

- CWL files use YAML syntax
- `cwlVersion` and `class` are required fields
- `inputs` define what data the tool accepts
- `outputs` define what the tool produces
- Job files provide actual values for inputs

## Next Steps

Once you've completed this exercise, move on to [Exercise 2: FITS Header Extraction](../02-fits-header/).
