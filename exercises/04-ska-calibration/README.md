# Exercise 4: SKA Calibration Pipeline

Build a realistic radio astronomy calibration pipeline using SKA tools and data formats.

## Learning Objectives

- Work with measurement sets (MS) - the standard radio astronomy data format
- Implement calibration and imaging steps
- Use conditional logic and subworkflows
- Handle complex data dependencies

## Background

Radio interferometry data processing involves several key steps:

1. **Flagging**: Remove bad data (RFI, malfunctioning antennas)
2. **Calibration**: Solve for instrumental and atmospheric effects
3. **Imaging**: Create sky images from calibrated visibilities
4. **Self-calibration**: Iterate to improve calibration using the sky model

### SKA Data Processing Context

The Square Kilometre Array will produce unprecedented data volumes. CWL workflows enable:
- Reproducible processing across different computing environments
- Scalable execution on HPC and cloud infrastructure
- Version-controlled pipeline definitions

## Exercise

### Step 1: Examine the Pipeline Structure

This exercise implements a simplified calibration pipeline:

```
Measurement Set
      ↓
  Flagging (aoflagger)
      ↓
  Bandpass Calibration
      ↓
  Gain Calibration
      ↓
  Apply Calibration
      ↓
  Imaging (wsclean)
      ↓
  Quality Assessment
```

### Step 2: Explore the Tools

Look at the tools in `tools/`:

- `flag-data.cwl`: RFI flagging using aoflagger strategies
- `calibrate-bandpass.cwl`: Solve for bandpass response
- `calibrate-gains.cwl`: Solve for time-variable gains
- `apply-calibration.cwl`: Apply solutions to data
- `make-image.cwl`: Create images with wsclean
- `assess-quality.cwl`: Compute quality metrics

### Step 3: Complete the Workflow

Fill in `ska-calibration.cwl`:

```yaml
cwlVersion: v1.2
class: Workflow

requirements:
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}
  InlineJavascriptRequirement: {}

inputs:
  measurement_set:
    type: Directory
    doc: Input measurement set
  
  calibrator_source:
    type: string
    doc: Name of calibrator source
  
  target_source:
    type: string
    doc: Name of target source
  
  imaging_params:
    type:
      type: record
      fields:
        - name: size
          type: int
        - name: scale
          type: string
        - name: niter
          type: int

steps:
  flag_data:
    run: tools/flag-data.cwl
    in:
      ms: measurement_set
    out: [flagged_ms, flag_summary]

  calibrate_bandpass:
    run: tools/calibrate-bandpass.cwl
    in:
      ms: flag_data/flagged_ms
      source: calibrator_source
    out: [bandpass_table]

  # Continue building the pipeline...

outputs:
  final_image:
    type: File
    outputSource: make_image/image
  
  quality_report:
    type: File
    outputSource: assess_quality/report
```

### Step 4: Run the Pipeline

```bash
cwltool ska-calibration.cwl ska-calibration-job.yml
```

### Step 5: Examine Outputs

- `final_image.fits`: The calibrated, deconvolved image
- `quality_report.json`: Metrics including noise, dynamic range, source counts

## Advanced Challenges

1. **Self-Calibration Loop**: Implement iterative self-calibration
2. **Parallel Processing**: Use scatter to process multiple spectral windows
3. **Conditional Execution**: Skip steps based on data quality checks
4. **Resource Hints**: Add ResourceRequirement for HPC deployment

## Key Takeaways

- CWL can express complex, realistic pipelines
- Subworkflows help organize large pipelines
- Requirements enable advanced features
- Record types handle structured parameters

## Resources

- [CASA Documentation](https://casa.nrao.edu/)
- [WSClean Documentation](https://wsclean.readthedocs.io/)
- [RASCIL Documentation](https://ska-telescope.gitlab.io/external/rascil/)
- [SKA Developer Portal](https://developer.skao.int/)
