class: CommandLineTool
cwlVersion: v1.0
id: cellranger_count
baseCommand: ['cellranger', 'count']
inputs:
  - id: fastq_dir
    type: Directory
  - id: genome_dir
    type: Directory
  - id: chemistry
    type: string?
    default: threeprime
  - id: analysis_flag
    type: boolean
    inputBinding:
      position: 6
      prefix: --nosecondary
outputs:
  - id: output
    type: File
    outputBinding:
      glob: '$(inputs.fastq_dir.basename)_run/outs/molecule_info.h5'
#      glob: '$(inputs.fastq_dir.dirname)/outs/molecule_info.h5'
      outputEval: |
        ${
          self[0].basename = inputs.fastq_dir.basename + '_molecule_info.h5';
          return self[0]
        }
label: cellr_count
arguments:
  - position: 1
    prefix: '--id='
    separate: false
    valueFrom: $(inputs.fastq_dir.basename)_run
  - position: 2
    prefix: '--fastqs='
    separate: false
    valueFrom: './$(inputs.fastq_dir.basename)'
  - position: 3
    prefix: '--transcriptome='
    separate: false
    valueFrom: './$(inputs.genome_dir.basename)'
  - position: 4
    prefix: '--chemistry='
    separate: false
    valueFrom: $(inputs.chemistry)
  - position: 5
    prefix: '--sample='
    separate: false
    valueFrom: $(inputs.fastq_dir.basename)
requirements:
  - class: DockerRequirement
    dockerPull: sagebionetworks/cellranger
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
  - class: InitialWorkDirRequirement
    listing:
    - entry: $(inputs.fastq_dir)
      entryname: $(inputs.fastq_dir.basename)
      writable: true
    - entry: $(inputs.genome_dir)
      entryname: $(inputs.genome_dir.basename)
      writable: true
