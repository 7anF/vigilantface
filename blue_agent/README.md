# blue_agent/ — Task 6 (DONE): attack detector

A ResNet-18 (ImageNet-pretrained, fine-tuned) that classifies a 160x160 face crop as **genuine, gan, fgsm, pgd or gan_adv**,
or answers **suspicious** when its top probability is below a threshold chosen on the validation set.
`attack probability = 1 − P(genuine)` is the signal the risk engine will use.

| Notebook | Trained on | Key results (held-out test) |
|---|---|---|
| `BlueAgent.ipynb` (v1) | Round-1 Red Agent data, 2,500 images | 99.2% accuracy, genuine-vs-attack AUC 1.000, 0% false alarms |
| `BlueAgent_v2.ipynb` (v2) | Round 1 + round 2 (stealthier attacks), 4,000 images, class-weighted | Full bypass of round-2 attacks 41.2% (v1) → 10.0% (v2); false alarms 5.5%; L2 attacks still 31% missed |

Design choices shared by both:
- **Split 70/15/15 by person** (asserted): a person's genuine, FGSM and PGD images never cross splits; v2 reuses v1's split exactly, so both models are compared on identical test images.
- **Anti-shortcut:** 30% of genuine training faces are randomly downscaled (160→64→160) or blurred and stay labelled genuine, so "blurry" does not mean "GAN".
- **Augmentation:** horizontal flip only; attack images are never resized or compressed (that would erase the perturbation).
- **`predict(image)`** at the end of each notebook returns the class probabilities, the attack probability and the decision; checkpoints are loaded with `torch.load(..., weights_only=True)`.

Outputs (`blue_agent_resnet18.pth`, `blue_agent_v2_resnet18.pth`, metrics CSVs and figures) are written to
`/workspace/celeba/blue_agent*/` on the RunPod volume and are not in git.
