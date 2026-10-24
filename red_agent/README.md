# red_agent/ — Tasks 4–5 (DONE): synthetic and adversarial faces

| Notebook | What it does | Key result |
|---|---|---|
| `RedAgent_DCGAN.ipynb` | DCGAN trained on the 32,597 train-split faces at 64x64 (epochs 1–25 local, 26–50 on RunPod) | Generator 3.58M params, final weights `generator_dcgan_50ep.pth` |
| `RedAgent_DCGAN_Evaluation.ipynb` | FID (pytorch-fid statistics), MTCNN detection rate, FaceNet best match | FID 18.72 at 50 epochs (31.45 at 25; real-vs-real 4.17) |
| `RedAgent_Attacks.ipynb` | **Round 1.** FGSM + PGD (ART, L-inf, eps 8/255, PGD 20 steps) against frozen FaceNet + a 300-identity linear head; 5 categories x 500 images: genuine, gan, fgsm, pgd, gan_adv | FGSM fools 99.2%, PGD 100% with 0.99 confidence in the wrong person |
| `RedAgent_Attacks_v2.ipynb` | **Round 2.** The same FGSM/PGD made stealthier against Blue Agent v1: `low_eps` (2–8/255), `l2`, and detector-aware `adaptive` attacks; 1,500 images | Full bypass of FaceNet + Blue v1: 0% (round 1) → 41% on held-out attacks |

Run order: DCGAN → DCGAN_Evaluation → Attacks → (`blue_agent/BlueAgent.ipynb`) → Attacks_v2.
`RedAgent_Attacks_v2` needs Blue Agent v1's `blue_agent/blue_agent_resnet18.pth` and `split.csv`, because it attacks that detector.

Inputs and outputs live in `/workspace/celeba/` on the RunPod volume (see `../runpod/README.md`); model weights,
image samples and zips are not in git. All attacks are white-box and untargeted; every perturbation is at most 8/255
per pixel and is measured after 8-bit PNG rounding.
