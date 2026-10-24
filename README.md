# VigilantFace

**Adaptive biometric defence against synthetic and adversarial face attacks** — graduation project (GP2), Applied Science Private University.

VigilantFace protects face-recognition login. A **Red Agent** attacks the recognition model with GAN-generated faces and adversarial noise (FGSM, PGD); a **Blue Agent** detects manipulated inputs; a risk engine (next) turns recognition confidence + attack probability + input quality into accept / reject / flag / honeypot, explained by a RAG module.

## Status

| # | Task | Status | Folder |
|---|---|---|---|
| 1 | Dataset: 46,581 CelebA faces, MTCNN 160x160, CLAHE, identity-disjoint 70/15/15 split | Done | `data/` |
| 2–3 | Face recognition (FaceNet / VGGFace2, Supabase pgvector) + evaluation: EER 0.28, accuracy 94.4% | Done | `face_recognition/` |
| 4 | DCGAN 64x64, 50 epochs, FID 18.72 | Done | `red_agent/` |
| 5 | FGSM + PGD (ART), 5 sample categories; round-2 stealthier attacks | Done | `red_agent/` |
| 6 | Blue Agent (ResNet-18, 5 classes + suspicious), v1 and v2 | Done | `blue_agent/` |
| 7 | Risk-scoring engine | Next | `risk_engine/` |
| 8–11 | Honeypot, RAG explainability, backend (RBAC), dashboard, Docker DMZ | Planned | see folder READMEs |

## Headline results

- **Attack:** PGD (≤ 8/255 per pixel) makes FaceNet pick the wrong person on 100% of faces with 0.99 confidence — higher than the 0.93 it gives real users.
- **Round 1:** Blue Agent v1 detects all round-1 attacks — 99.2% 5-class test accuracy, genuine-vs-attack AUC 1.000, 0% false alarms.
- **Round 2:** Red Agent v2 (mixed strength, L2, detector-aware attacks) gets past FaceNet + Blue v1 on 41.2% of held-out attacks; Blue Agent v2, retrained on both rounds, cuts that to 10.0% (false alarms 5.5%). Low-energy L2 noise remains the weak spot.

## Run order

1. `data/Dataset.ipynb`
2. `face_recognition/Face_Rcognition.ipynb` (needs `SUPABASE_DB_URL` in a local `.env`; never commit it)
3. `red_agent/RedAgent_DCGAN.ipynb` → `red_agent/RedAgent_DCGAN_Evaluation.ipynb`
4. `red_agent/RedAgent_Attacks.ipynb` (round 1)
5. `blue_agent/BlueAgent.ipynb` (Blue v1)
6. `red_agent/RedAgent_Attacks_v2.ipynb` (round 2, attacks Blue v1)
7. `blue_agent/BlueAgent_v2.ipynb` (Blue v2 + v1-vs-v2 comparison)

GPU notebooks run on RunPod with a persistent network volume — setup in [`runpod/README.md`](runpod/README.md).
Data, model weights and generated images are **not** in git (too large); notebooks keep their outputs so results are visible on GitHub.
The original 3-month build plan is in [`docs/BUILD_PIPELINE.md`](docs/BUILD_PIPELINE.md).

## Stack

PyTorch 2.8 · torchvision · facenet-pytorch · Adversarial Robustness Toolbox 1.20 · pytorch-fid · scikit-learn · Supabase (PostgreSQL + pgvector) · RunPod GPUs
