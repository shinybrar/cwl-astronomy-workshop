#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow

doc: |
  SKA Radio Astronomy Calibration and Imaging Pipeline
  
  This workflow implements a standard radio interferometry calibration
  procedure including flagging, bandpass calibration, gain calibration,
  and imaging with quality assessment.

label: SKA Calibration Pipeline

requirements:
  SubworkflowFeatureRequirement: {}
  InlineJavascriptRequirement: {}

inputs:
  measurement_set:
    type: Directory
    doc: Input measurement set containing raw visibilities
  
  calibrator_source:
    type: string
    doc: Name of the calibrator source for bandpass/gain solutions
  
  target_source:
    type: string
    doc: Name of the target source to image
  
  flagging_strategy:
    type: string
    default: "ska-default"
    doc: RFI flagging strategy to use
  
  solution_interval:
    type: float
    default: 60.0
    doc: Gain solution interval in seconds
  
  image_size:
    type: int
    default: 2048
    doc: Output image size in pixels
  
  pixel_scale:
    type: string
    default: "1asec"
    doc: Pixel scale for imaging
  
  clean_iterations:
    type: int
    default: 50000
    doc: Number of CLEAN iterations

outputs:
  final_image:
    type: File
    doc: Final calibrated and deconvolved image
    outputSource: make_image/image
  
  quality_report:
    type: File
    doc: Image quality metrics
    outputSource: assess_quality/report
  
  flag_summary:
    type: File
    doc: Flagging statistics
    outputSource: flag_data/flag_summary
  
  bandpass_table:
    type: File
    doc: Bandpass calibration solutions
    outputSource: calibrate_bandpass/bandpass_table
  
  gain_table:
    type: File
    doc: Gain calibration solutions
    outputSource: calibrate_gains/gain_table
  
  imaging_summary:
    type: File
    doc: Imaging parameters and statistics
    outputSource: make_image/imaging_summary

steps:
  flag_data:
    doc: Flag RFI and bad data
    run: tools/flag-data.cwl
    in:
      ms: measurement_set
      strategy: flagging_strategy
    out: [flagged_ms, flag_summary]

  calibrate_bandpass:
    doc: Solve for bandpass response
    run: tools/calibrate-bandpass.cwl
    in:
      ms: flag_data/flagged_ms
      source: calibrator_source
    out: [bandpass_table]

  calibrate_gains:
    doc: Solve for time-variable gains
    run: tools/calibrate-gains.cwl
    in:
      ms: flag_data/flagged_ms
      source: calibrator_source
      bandpass_table: calibrate_bandpass/bandpass_table
      solution_interval: solution_interval
    out: [gain_table]

  apply_calibration:
    doc: Apply calibration to target data
    run: tools/apply-calibration.cwl
    in:
      ms: flag_data/flagged_ms
      bandpass_table: calibrate_bandpass/bandpass_table
      gain_table: calibrate_gains/gain_table
      target_source: target_source
    out: [calibrated_ms, apply_summary]

  make_image:
    doc: Create image from calibrated visibilities
    run: tools/make-image.cwl
    in:
      ms: apply_calibration/calibrated_ms
      name:
        default: "ska-target"
      size: image_size
      scale: pixel_scale
      niter: clean_iterations
    out: [image, imaging_summary]

  assess_quality:
    doc: Assess final image quality
    run: tools/assess-quality.cwl
    in:
      image: make_image/image
    out: [report]
