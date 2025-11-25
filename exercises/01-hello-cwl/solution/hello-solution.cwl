#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

doc: |
  Solution for Exercise 1 challenge.
  Accepts a name parameter and outputs a personalized welcome message.

label: Hello CWL - Solution

baseCommand: ["/bin/sh", "-c"]

inputs:
  name:
    type: string
    doc: The name to greet

arguments:
  - valueFrom: |
      echo "Hello, $(inputs.name)! Welcome to CWL."
    position: 1

outputs:
  output:
    type: stdout

stdout: hello-output.txt
