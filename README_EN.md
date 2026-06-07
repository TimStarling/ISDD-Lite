<div align="right">

[中文](README.md) | [English](README_EN.md)

</div>

# ISDD-Lite

`ISDD-Lite` is a lightweight industrial defect-detection project based on PaddleDetection. The current release provides an `SSD-MobileNetV1 + QAT` model suitable for edge devices, embedded platforms, and resource-constrained deployment.

## Model Purpose

The model detects industrial defects in images and supports five categories:

- `ca_shang`
- `zang_wu`
- `zhe_zhou`
- `zhen_kong`
- `zheng_chang`

## Included Content

- `ppdet/`: PaddleDetection runtime core code
- `tools/`: training, evaluation, inference, and export entry points
- `configs/`: model configuration
- `dataset/isdd-dataset-voc/`: dataset used by this project
- `output/ssd_mobilenet_v1_qat/`: best training weights
- `output_inference/ssd_mobilenet_v1_qat/`: exported inference model
- `ssd_mobilenet_v1_opt.nb`: Paddle Lite optimized model
