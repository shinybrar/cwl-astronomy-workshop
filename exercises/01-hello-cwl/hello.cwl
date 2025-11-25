#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

doc: |
  A simple "Hello World" CWL tool that demonstrates basic CWL concepts.
  This tool echoes a message to a file.

label: Hello CWL

baseCommand: echo

inputs:
  message:
    type: string
    doc: The message to display
    inputBinding:
      position: 1

outputs:
  output:
    type: stdout
    doc: The output file containing the message

stdout: hello-output.txt
