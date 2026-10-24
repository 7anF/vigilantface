# runpod/ — GPU infrastructure

All GPU notebooks run on rented [RunPod](https://www.runpod.io) pods attached to one persistent **network volume**, edited from VS Code on a PC.

| Item | Setup |
|---|---|
| Network volume | `vigilantface`, 30 GB, region EUR-IS-2, mounted at `/workspace` on every pod |
| Pod template | RunPod PyTorch (PyTorch 2.8.0 + CUDA 12.8) |
| GPUs used | RTX 4090, L40S, RTX PRO 6000 MIG 24 GB — any GPU with ≥ 16 GB works |
| Packages | `install.sh` (this folder): ART 1.20.1, facenet-pytorch (`--no-deps`), pytorch-fid, scikit-learn, pandas, matplotlib |

## Layout on the volume

```
/workspace/
├── install.sh                  copy of runpod/install.sh
├── .cache/                     pip + FaceNet / ResNet-18 / Inception weights (kept between pods)
├── notebooks/                  optional copies of the notebooks
└── celeba/                     BASE folder of every notebook (os.chdir("/workspace") then ./celeba/...)
    ├── preprocessed_v2/        46,581 faces, 160x160 PNG (from data/preprocessed_v2.zip)
    ├── train_split.csv  val_split.csv  test_split.csv
    ├── generator_dcgan_50ep.pth  generator_dcgan_25ep.pth  dcgan_checkpoint_50ep.pth
    ├── identity_head.pth  head_identities.csv          <- RedAgent_Attacks (attack target)
    ├── red_agent_samples/      <- RedAgent_Attacks     (round 1: 5 categories x 500)
    ├── red_agent_samples_v2/   <- RedAgent_Attacks_v2  (round 2: 1,500 stealthier attacks)
    ├── blue_agent/             <- BlueAgent            (model, split, metrics, figures)
    ├── blue_agent_v2/          <- BlueAgent_v2
    └── dcgan_eval/             <- RedAgent_DCGAN_Evaluation
```

## First-time setup (once per volume)

```bat
:: Windows CMD on the PC, from the project folder (IP / port from the pod's "SSH over exposed TCP")
ssh root@<IP> -p <PORT> -i %USERPROFILE%\.ssh\id_ed25519 "mkdir -p /workspace/celeba /workspace/notebooks"
scp -P <PORT> -i %USERPROFILE%\.ssh\id_ed25519 data\preprocessed_v2.zip data\train_split.csv data\val_split.csv data\test_split.csv red_agent\models\generator_dcgan_50ep.pth red_agent\models\dcgan_checkpoint_50ep.pth root@<IP>:/workspace/celeba/
scp -P <PORT> -i %USERPROFILE%\.ssh\id_ed25519 red_agent\models\generator_dcgan.pth root@<IP>:/workspace/celeba/generator_dcgan_25ep.pth
scp -P <PORT> -i %USERPROFILE%\.ssh\id_ed25519 runpod\install.sh root@<IP>:/workspace/
```

```bash
# on the pod
cd /workspace/celeba && python -m zipfile -e preprocessed_v2.zip . && rm preprocessed_v2.zip
bash /workspace/install.sh
```

## Every new pod

1. Storage → `vigilantface` → Deploy (same region), RunPod PyTorch template.
2. SSH in: `bash /workspace/install.sh` (about 30 s).
3. VS Code → Select Kernel → Existing Jupyter Server → the pod's Jupyter link **with** `?token=...`.
4. Run cell 1 of a notebook: it must print `working directory: /workspace` and `device: cuda`.
5. Copy results back with `scp`, then **Terminate** the pod (the volume keeps everything).

Never commit a pod's Jupyter token, IP or SSH key; they change with every pod.
