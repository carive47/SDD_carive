# Índice de context packs

Menú que `sdd-scaffold` lee para ofrecerte los dominios/stacks disponibles.
Cada pack aporta: principios de constitución + RFs comunes (EARS) + casos límite.

| Pack | Aporta | Usar cuando |
|---|---|---|
| `ingestion` | Fuentes de datos, validación, idempotencia, late-data | El proyecto lee datos de fuera (DB, API, CSV, streams, archivos) |
| `etl` | Transformaciones, órdenes, reintentos, checkpoints | Hay pipelines de transformación de datos |
| `api-backend` | REST/GraphQL, auth, errores, paginación, rate-limit | Construyes un servicio/API |
| `llm-pipeline` | Prompts, embeddings, chunking, evaluación, costes | Trabajas con LLMs / RAG / agentes |
| `cli-tool` | argparse/CLI, códigos de salida, stdout/stderr | Herramienta de terminal |
| `infra-stack-python` | stdlib vs deps, pytest, type hints, empaquetado | El stack es Python |

Los packs se **componen**: se seleccionan varios y sus principios/RFs se fusionan
sobre la constitución base. Si dos packs se contradicen, el agente lo marca y
pregunta.
