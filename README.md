# ISDD-Lite

`ISDD-Lite` 是一个基于 PaddleDetection 的轻量化工业缺陷检测项目，当前提供的是 `SSD-MobileNetV1 + QAT` 模型，适合在边缘设备、嵌入式平台和资源受限环境中部署。项目可用于铝片表面缺陷识别、工业视觉质检、自动化巡检等场景，也可作为机器人与人工智能大赛、集成电路创新创业大赛海云捷讯/皓耀赛道的基础算法项目。

## 1. 模型用途

当前模型用于图像中的工业缺陷检测，支持以下 5 个类别：

- `ca_shang`
- `zang_wu`
- `zhe_zhou`
- `zhen_kong`
- `zheng_chang`

当前模型信息：

- 检测架构：`SSD`
- 骨干网络：`MobileNetV1`
- 训练方式：`QAT` 量化感知训练
- 输入尺寸：`300 x 300`
- 评估指标：`VOC`

## 2. 当前保留内容

本仓库已经按开源发布做了精简，仅保留运行当前模型所需的核心内容：

- `ppdet/`：PaddleDetection 运行核心代码
- `tools/`：训练、评估、推理、导出入口
- `configs/`：当前模型所需配置
- `dataset/isdd-dataset-voc/`：当前数据集
- `output/ssd_mobilenet_v1_qat/`：最佳训练权重
- `output_inference/ssd_mobilenet_v1_qat/`：导出的推理模型
- `ssd_mobilenet_v1_opt.nb`：Paddle Lite 优化模型

训练环境不会随仓库一起提供，需要使用者自行配置。

## 3. 项目结构

```text
PaddleDetection/
├─ configs/
│  ├─ datasets/
│  │  └─ voc.yml
│  ├─ ssd/
│  │  ├─ _base_/
│  │  │  ├─ optimizer_120e.yml
│  │  │  ├─ ssd_mobilenet_reader.yml
│  │  │  └─ ssd_mobilenet_v1_300.yml
│  │  └─ ssd_mobilenet_v1_300_120e_voc.yml
│  ├─ slim/
│  │  └─ quant/
│  │     └─ ssd_mobilenet_v1_qat.yml
│  └─ runtime.yml
├─ dataset/
│  └─ isdd-dataset-voc/
│     ├─ images/
│     ├─ annotations/
│     ├─ label_list.txt
│     ├─ train.txt
│     ├─ val.txt
│     ├─ test.txt
│     └─ trainval.txt
├─ output/
│  └─ ssd_mobilenet_v1_qat/
│     ├─ best_model.pdparams
│     └─ best_model.pdopt
├─ output_inference/
│  └─ ssd_mobilenet_v1_qat/
│     ├─ infer_cfg.yml
│     ├─ model.pdmodel
│     ├─ model.pdiparams
│     └─ model.pdiparams.info
├─ ppdet/
├─ tools/
├─ requirements.txt
├─ setup.py
├─ ssd_mobilenet_v1_opt.nb
├─ LICENSE
└─ README.md
```

## 4. 数据集说明

项目使用 VOC 格式数据集，路径为 `dataset/isdd-dataset-voc`。

数据集结构说明：

- `images/`：原始图像
- `annotations/`：VOC XML 标注文件
- `label_list.txt`：类别列表
- `train.txt` / `val.txt` / `test.txt`：数据划分文件
- `trainval.txt`：训练集合并文件

当前数据划分规模：

- 训练集：205 张
- 验证集：23 张
- 测试集：13 张

## 5. 环境配置方法

本仓库不包含现成训练环境，使用前请自行配置 Python 与 PaddlePaddle 环境。建议使用单独虚拟环境。

### 5.1 创建虚拟环境

推荐使用 `conda`：

```bash
conda create -n isdd-lite python=3.7
conda activate isdd-lite
```

如果你使用 `venv`，也可以自行创建等效环境。

### 5.2 安装 PaddlePaddle

根据你的设备选择 CPU 或 GPU 版本。

CPU 版本示例：

```bash
pip install paddlepaddle
```

GPU 版本示例：

```bash
pip install paddlepaddle-gpu
```

如果使用 GPU，请确保：

- PaddlePaddle 版本与 CUDA 版本匹配
- 显卡驱动和 CUDA 环境已正确安装

建议优先参考 PaddlePaddle 官方安装说明，选择与你本机环境对应的安装命令。

### 5.3 安装项目依赖

```bash
pip install -r requirements.txt
python setup.py install
```

### 5.4 验证环境

可先执行以下命令验证是否安装成功：

```bash
python tools/infer.py -h
```

如果能正常输出帮助信息，说明基础运行环境已可用。

## 6. 如何训练

当前训练依赖以下两个配置文件：

- 基础检测配置：`configs/ssd/ssd_mobilenet_v1_300_120e_voc.yml`
- 量化训练配置：`configs/slim/quant/ssd_mobilenet_v1_qat.yml`

训练命令：

```bash
python tools/train.py -c configs/ssd/ssd_mobilenet_v1_300_120e_voc.yml \
  --slim_config configs/slim/quant/ssd_mobilenet_v1_qat.yml
```

训练输出目录：

```text
output/ssd_mobilenet_v1_qat
```

## 7. 模型评估

```bash
python tools/eval.py -c configs/ssd/ssd_mobilenet_v1_300_120e_voc.yml \
  --slim_config configs/slim/quant/ssd_mobilenet_v1_qat.yml \
  -o weights=output/ssd_mobilenet_v1_qat/best_model.pdparams
```

## 8. 导出推理模型

```bash
python tools/export_model.py -c configs/ssd/ssd_mobilenet_v1_300_120e_voc.yml \
  --slim_config configs/slim/quant/ssd_mobilenet_v1_qat.yml \
  -o weights=output/ssd_mobilenet_v1_qat/best_model.pdparams
```

导出结果目录：

```text
output_inference/ssd_mobilenet_v1_qat
```

## 9. 单张图片推理

```bash
python tools/infer.py -c configs/ssd/ssd_mobilenet_v1_300_120e_voc.yml \
  --slim_config configs/slim/quant/ssd_mobilenet_v1_qat.yml \
  -o weights=output/ssd_mobilenet_v1_qat/best_model.pdparams \
  --infer_img=path/to/your_image.jpg
```

推理可视化结果默认保存在 `output/` 目录。

## 10. 如何继续调整和训练

如果要在当前模型基础上继续训练或做迁移学习，重点修改以下内容。

### 10.1 修改类别

需要同步修改：

- `dataset/isdd-dataset-voc/label_list.txt`
- `configs/datasets/voc.yml`

注意：

- `label_list.txt` 中类别顺序必须固定
- XML 标注中的类别名必须与 `label_list.txt` 完全一致
- `configs/datasets/voc.yml` 中 `num_classes` 必须与类别数一致

### 10.2 替换数据集

如果换成自己的数据集，建议保持 VOC 目录格式：

```text
dataset/your_dataset/
├─ images/
├─ annotations/
├─ label_list.txt
├─ train.txt
├─ val.txt
├─ test.txt
└─ trainval.txt
```

然后修改 `configs/datasets/voc.yml` 中的：

```yaml
dataset_dir: dataset/your_dataset
anno_path: trainval.txt
label_list: label_list.txt
num_classes: your_class_num
```

### 10.3 调整训练策略

主要修改以下配置：

- `configs/ssd/ssd_mobilenet_v1_300_120e_voc.yml`
- `configs/ssd/_base_/optimizer_120e.yml`

常见调整项：

- 训练轮数
- 学习率
- batch size
- 学习率衰减策略

### 10.4 调整量化参数

量化相关配置位于：

- `configs/slim/quant/ssd_mobilenet_v1_qat.yml`

常见可调参数：

- `weight_bits`
- `activation_bits`
- `moving_rate`
- `quantizable_layer_type`


