#!/usr/bin/env bash
# VigilantFace - run once on every NEW RunPod pod (RunPod PyTorch template, network volume mounted at /workspace):
#   bash /workspace/install.sh
# Data, models and notebooks live on the volume; only the Python packages live on the pod's own disk.
mkdir -p /workspace/.cache
[ -L ~/.cache ] || { rm -rf ~/.cache; ln -s /workspace/.cache ~/.cache; }   # keep pip / FaceNet / ResNet / Inception downloads on the volume
pip install -q --break-system-packages adversarial-robustness-toolbox pytorch-fid matplotlib pandas scikit-learn
pip install -q --break-system-packages --no-deps facenet-pytorch                 # its old torch pins conflict with the template's PyTorch
python -c "import torch,art,facenet_pytorch,pytorch_fid; print('torch',torch.__version__,'| GPU',torch.cuda.get_device_name(0),'| ART',art.__version__)"
echo "images: $(ls /workspace/celeba/preprocessed_v2 2>/dev/null | wc -l)"; ls /workspace/celeba
