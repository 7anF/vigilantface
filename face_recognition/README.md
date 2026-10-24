# face_recognition/ — Tasks 2–3 (DONE)

`Face_Rcognition.ipynb` — FaceNet (InceptionResnetV1, pretrained `vggface2`) → 512-d L2-normalized embeddings,
enrollment into Supabase `face_embeddings` (pgvector), verification by cosine similarity (`<=>`), and evaluation.

Needs `SUPABASE_DB_URL` in a `.env` file (never commit it). The saved output that printed the real URL has been redacted in this copy.
Results: see `../evaluation/face_recognition_results.md`.
