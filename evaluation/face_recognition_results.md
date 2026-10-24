# Face Recognition Evaluation (from Face_Rcognition.ipynb saved outputs)

## Pair verification — val split (1,401 genuine + 1,401 impostor pairs)
Genuine mean similarity 0.6335 · impostor mean 0.0457 · EER threshold **0.28**

| Metric | Value |
|---|---|
| Accuracy | 0.9436 |
| Precision | 0.9423 |
| Recall | 0.9450 |
| F1 | 0.9437 |
| FAR | 0.0578 |
| FRR | 0.0550 |
| TP / FP / FN / TN | 1324 / 81 / 77 / 1320 |

## Gallery test — 500 enrolled (train) vs 500 never-enrolled (val) queries, threshold 0.70

| Metric | Value |
|---|---|
| Accuracy | 0.9040 |
| Precision | 0.8389 |
| Recall | 1.0000 |
| F1 | 0.9124 |
| FAR | 0.1920 |
| FRR | 0.0000 |

# Red Agent attack results
See `red_agent_attack_results.csv` — identity accuracy drops from 1.00 (genuine) to 0.016 (FGSM) and 0.00 (PGD) at eps = 8/255.
