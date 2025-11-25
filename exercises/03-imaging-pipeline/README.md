# Exercise 3: Imaging Pipeline

Build a multi-step workflow that chains multiple tools together. This exercise introduces CWL Workflows.

## Learning Objectives

- Create CWL Workflows (not just CommandLineTools)
- Connect tool outputs to inputs (data flow)
- Use scatter to process multiple files
- Understand workflow steps and dependencies

## Background

Real data processing involves multiple steps. CWL Workflows let you define how tools connect together, with the runtime handling data flow and parallelization.

### Key Concepts

1. **Workflow class**: Orchestrates multiple tools
2. **steps**: Individual operations in the workflow
3. **in/out**: Connect step inputs to workflow inputs or other step outputs
4. **scatter**: Process multiple items in parallel

## Exercise

### Step 1: Understand the Pipeline

We'll build a simple imaging pipeline:

```
FITS Image → Statistics → Thumbnail → Report
     ↓
  Header Extraction ────────────────→ Report
```

### Step 2: Examine the Individual Tools

Look at the tools in the `tools/` directory:

- `image-stats.cwl`: Calculate image statistics
- `make-thumbnail.cwl`: Create a thumbnail preview
- `extract-header.cwl`: Extract FITS header (from Exercise 2)
- `generate-report.cwl`: Combine results into a report

### Step 3: Build the Workflow

Complete `imaging-pipeline.cwl`:

```yaml
cwlVersion: v1.2
class: Workflow

doc: |
  A multi-step imaging pipeline that processes FITS files
  and generates a summary report.

inputs:
  fits_image:
    type: File
    doc: Input FITS image

outputs:
  report:
    type: File
    outputSource: generate_report/report
  thumbnail:
    type: File
    outputSource: make_thumbnail/thumbnail

steps:
  extract_header:
    run: tools/extract-header.cwl
    in:
      fits_file: fits_image
    out: [header_json]

  calculate_stats:
    run: tools/image-stats.cwl
    in:
      fits_file: fits_image
    out: [stats_json]

  make_thumbnail:
    run: tools/make-thumbnail.cwl
    in:
      fits_file: fits_image
    out: [thumbnail]

  generate_report:
    run: tools/generate-report.cwl
    in:
      header: extract_header/header_json
      stats: calculate_stats/stats_json
      thumbnail: make_thumbnail/thumbnail
    out: [report]
```

### Step 4: Run the Pipeline

```bash
cwltool imaging-pipeline.cwl imaging-pipeline-job.yml
```

### Step 5: Process Multiple Files with Scatter

Modify the workflow to process multiple FITS files:

```yaml
inputs:
  fits_images:
    type: File[]

requirements:
  ScatterFeatureRequirement: {}

steps:
  extract_header:
    run: tools/extract-header.cwl
    scatter: fits_file
    in:
      fits_file: fits_images
    out: [header_json]
```

## Challenge

1. Add error handling for corrupted FITS files
2. Make the thumbnail size configurable
3. Add a step to detect sources in the image
4. Output a combined summary for all processed files

## Key Takeaways

- Workflows connect multiple tools
- Data flows through step connections
- Scatter enables parallel processing
- CWL runtime handles dependency ordering

## Next Steps

Continue to [Exercise 4: SKA Calibration Pipeline](../04-ska-calibration/).
