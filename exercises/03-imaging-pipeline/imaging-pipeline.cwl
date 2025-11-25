#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow

doc: |
  A multi-step imaging pipeline that processes FITS files
  and generates a comprehensive analysis report.
  
  Pipeline steps:
  1. Extract FITS header metadata
  2. Calculate image statistics
  3. Generate thumbnail preview
  4. Combine all outputs into HTML report

label: FITS Imaging Pipeline

inputs:
  fits_image:
    type: File
    doc: Input FITS image to process

outputs:
  report:
    type: File
    doc: HTML report combining all analysis results
    outputSource: generate_report/report
  
  thumbnail:
    type: File
    doc: PNG thumbnail of the image
    outputSource: make_thumbnail/thumbnail
  
  header_json:
    type: File
    doc: JSON file with header metadata
    outputSource: extract_header/header_json
  
  stats_json:
    type: File
    doc: JSON file with image statistics
    outputSource: calculate_stats/stats_json

steps:
  extract_header:
    doc: Extract metadata from FITS header
    run: tools/extract-header.cwl
    in:
      fits_file: fits_image
      output_name:
        default: "header.json"
    out: [header_json]

  calculate_stats:
    doc: Calculate image statistics
    run: tools/image-stats.cwl
    in:
      fits_file: fits_image
      output_name:
        default: "stats.json"
    out: [stats_json]

  make_thumbnail:
    doc: Generate thumbnail preview
    run: tools/make-thumbnail.cwl
    in:
      fits_file: fits_image
      output_name:
        default: "thumbnail.png"
    out: [thumbnail]

  generate_report:
    doc: Combine results into HTML report
    run: tools/generate-report.cwl
    in:
      header: extract_header/header_json
      stats: calculate_stats/stats_json
      thumbnail: make_thumbnail/thumbnail
      output_name:
        default: "analysis-report.html"
    out: [report]
