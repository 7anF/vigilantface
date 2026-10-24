# data/ — Task 1 (DONE)

| File | What it is |
|---|---|
| `Dataset.ipynb` | Week 1 preprocessing notebook (MTCNN crop/align 160x160, CLAHE, identity-disjoint split) |
| `preprocessed_v2.zip` | 46,581 preprocessed CelebA faces (PNG, 160x160). Extract here → `data/preprocessed_v2/` |
| `manifest_v2.csv` | Source of truth: `image_id, file_name, identity, det_prob, label, source` |
| `train_split.csv` / `val_split.csv` / `test_split.csv` | Identity-disjoint splits (32,597 / 6,986 / 6,997 images) |
| `skipped_v2.csv` | Images rejected by MTCNN (no face / confidence < 0.90) |
| `VigilantFace_Dataset_Documentation.pdf` | Full dataset documentation |
| `legacy/PRE1_preprocessed_v1_superseded.zip` | First 199-image test run (JPG, superseded by v2) |

Note: the notebooks were written with paths like `./celeba/preprocessed_v2` and `./celeba/train_split.csv`.
Update `base_path` in each notebook to point at this `data/` folder before re-running.
