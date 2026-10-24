# VigilantFace — 3-Month Build Pipeline (GP2)
**Autonomous Adversarial Simulation and Adaptive Biometric Defense**


## 0. Scope for 3 Months

Our GP1 report describes: face recognition + GAN generator + FGSM/PGD attacks + Blue Agent detector + risk-scoring engine + honeypot + RAG explainability + DMZ cloud architecture + full-stack dashboard. That's roughly 8 subsystems. Built at full depth, each alone is a semester project.

**Strategy:** build a working end-to-end pipeline first (thin slice through all 8 pieces), then deepen the pieces that matter most for our demo/defense (Red Agent, Blue Agent, risk engine — these are your core contribution). DMZ cloud infra and Grafana monitoring get the simplest version that still "counts."

| Component | Full GP1 vision | MVP for 3 months |
|---|---|---|
| Face recognition | Custom-trained model | Pretrained FaceNet/ArcFace via `deepface` library, fine-tune only if time allows |
| Red Agent (GAN) | Custom GAN trained from scratch | Pretrained StyleGAN2/StyleGAN3 or a lightweight DCGAN on CelebA subset |
| Attacks | FGSM + PGD + Carlini-Wagner | FGSM + PGD (as report states) via **ART (Adversarial Robustness Toolbox)** — don't hand-roll |
| Blue Agent | Custom deep detector | Binary/multi-class CNN classifier trained on your 4 sample categories |
| Risk engine | Full dynamic scoring | Weighted rule-based formula first, ML classifier as stretch goal |
| Honeypot | Real isolated environment | Simulated redirect + logging (a fake "decoy" endpoint that logs attacker behavior) |
| RAG explainability | Full LangChain + vector DB | LangChain + FAISS + small curated knowledge base (20–40 docs you write yourself) |
| DMZ / Cloud | Real DMZ network segmentation | Docker Compose with a public-facing API layer container + isolated internal-services network — architecturally correct, cloud-deployable later |

---

## 1. Month-by-Month Pipeline

### **Month 1 — Foundations & Core Recognition (Weeks 1–4)**
*Goal: working face recognition pipeline + dataset ready + dev environment set up.*

**task 1 — Setup & Dataset**  ---> Done
- Set up Python env (conda/venv), GPU access (Colab Pro / local CUDA). ---> Done
- Download CelebA, explore it (identities, attributes, landmarks).
- Preprocessing pipeline: face detection + cropping (MTCNN or `mediapipe`), resizing, normalization, alignment.
- Study: CNN basics, how embeddings work (if not solid yet).

**task 2 — Face Recognition Module**  ---> Done
- Integrate `deepface` (wraps FaceNet, ArcFace, etc.) or `facenet-pytorch`.
- Build enrollment flow: image → embedding → store in DB. ---> done by Ajouz
- Build verification flow: new image → embedding → cosine similarity match. --->
- Study: triplet loss, ArcFace angular margin loss (conceptually — you're using pretrained, but you'll be asked about this in defense).

**task 3 — Baseline Evaluation + DB Design** --> DONE
- Implement evaluation metrics: Accuracy, Precision, Recall, F1, FAR, FRR.
- Finalize your DB schema (matches your ER diagram) — Supabase (Postgres) recommended since you already use it at work.
- Set up tables: users, enrollments, authentication_logs, risk_scores.

**task 4 — GAN Component (Red Agent, Part 1)** --> DONE
- Study: GAN fundamentals (Generator/Discriminator, adversarial loss).
- Get a pretrained GAN (StyleGAN2) running for face generation, OR train a small DCGAN on a CelebA subset if you want "trained by you" for the defense.
- Milestone check: you can enroll a face, verify a face, and generate a synthetic face.

----> First Month Done 

---

### **Month 2 — Adversarial Simulation & Defense (Weeks 5–8)**
*Goal: Red Agent + Blue Agent + risk engine working together.*

**task 5 — Adversarial Attacks (Red Agent, Part 2)** --> **DONE
- Study: FGSM (one-step gradient attack) and PGD (iterative attack) — know the math for your defense.
- Implement using **ART (Adversarial Robustness Toolbox)** against your face recognition model.
- Generate your 4 sample categories: genuine, GAN-generated, FGSM-attacked, PGD-attacked.

**task 6 — Blue Agent (Detection)**
- Build a classifier (CNN) trained on the 4 categories to detect genuine vs. manipulated/adversarial input.
- Study: adversarial detection literature (your report's section 1.2.4) — statistical detection, feature-squeezing, etc., to justify your design choice.
- Evaluate: detection accuracy per category, confusion matrix.

**task 7 — Risk-Scoring Engine**
- Design the scoring formula: combine recognition confidence + Blue Agent detection probability + input quality score → risk score.
- Define thresholds: Accept / Reject / Flag / Redirect-to-honeypot.
- Implement as a simple weighted-sum module first (explainable, defensible); optionally upgrade to a trained classifier later.

**task 8 — Honeypot + Integration Checkpoint**
- Build the simulated honeypot: a decoy endpoint that logs redirected sessions (IP-like metadata, timestamp, risk score, attempted image) without real backend exposure.
- Integration test: face image → recognition → Blue Agent check → risk score → decision → (if needed) honeypot redirect.
- Milestone check: full detection pipeline runs end-to-end on a single input.

---

### **Month 3 — Explainability, System, Deployment, Polish (Weeks 9–12)**
*Goal: RAG explainability + backend/frontend + DMZ-style deployment + evaluation + defense prep.*

**task 9 — RAG Explainability Module**
- Study: RAG architecture (retriever + generator), vector embeddings, LangChain basics — this overlaps with your TechVancer RAG chatbot experience, so this should move fast for you.
- Build knowledge base: write 20–40 short docs describing security rules, attack types, decision logic.
- Set up FAISS vector store + LangChain retrieval chain + an LLM (Gemini, since you already use it at work) to generate natural-language justifications for each decision.

**task 10 — Backend & API**
- Build Node.js/Express REST API gateway connecting: frontend, face recognition service, Red/Blue Agents, risk engine, RAG module, Supabase.
- Implement RBAC (Admin / Security Analyst / Authorized User) — you already have this pattern from your school portal project, reuse the approach.

**task 11 — Frontend Dashboard + DMZ-style Deployment**
- Build minimal dashboard: login/verify screen for users, admin panel (logs, risk scores, AI explanations) for analysts.
- Dockerize each component; separate into "public" (API gateway, frontend) vs "internal" (AI models, DB) Docker networks to mirror DMZ logically.
- Optional: basic Grafana/Prometheus dashboard for monitoring, if time allows — otherwise document it as future work.

**task 12 — Evaluation, Documentation, Defense Prep**
- Run full evaluation suite: recognition metrics, adversarial robustness (accuracy under FGSM/PGD), detection accuracy, risk-decision correctness.
- Compare system performance: normal vs. adversarial conditions (this is your key result).
- Write up GP2 report sections, prepare slides, rehearse explaining each module (especially Red/Blue Agent interaction and risk logic — these will get the most defense questions).

---

## 2. What You Need to Study (Prioritized)

**Must know deeply (you'll be questioned on these in defense):**
1. Face recognition embeddings — how FaceNet/ArcFace turn a face into a vector, cosine similarity matching.
2. Adversarial attacks — FGSM (gradient sign, one-step) and PGD (iterative, epsilon-ball projection). Know the math, not just the library call.
3. GANs — Generator vs Discriminator, adversarial minimax loss, why GAN-generated ≠ same as FGSM/PGD-perturbed.
4. Risk-scoring logic — be ready to justify your weights/thresholds, not just "the model said so."
5. RAG — retriever + vector DB + LLM generation; you already have real experience here from TechVancer, lean on it.

**Should know (implementation-level, learn as you build):**
- `deepface` / `facenet-pytorch` APIs
- ART (Adversarial Robustness Toolbox) usage
- LangChain + FAISS setup
- Docker / Docker Compose networking basics
- Supabase (Postgres) schema design — you already know this

**Nice to know (mention conceptually, don't need to build):**
- Real DMZ network security architecture
- Prometheus/Grafana monitoring
- Honeypot research (cite it, simulate it)

---


## 4. Suggested Repo Structure

```
vigilantface/
├── data/                  # CelebA subset, preprocessed samples
├── face_recognition/      # enrollment, verification, embeddings
├── red_agent/             # GAN generation, FGSM/PGD attacks
├── blue_agent/             # detection classifier
├── risk_engine/           # scoring logic, decision thresholds
├── honeypot/               # decoy endpoint + logging
├── rag_explainability/     # knowledge base, LangChain pipeline
├── backend/                # Node/Express API gateway
├── frontend/                # dashboard (React/TS)
├── docker/                  # per-service Dockerfiles + compose
└── evaluation/               # metrics scripts, results
```
