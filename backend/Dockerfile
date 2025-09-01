# Python + uv tabanlı imaj
FROM ghcr.io/astral-sh/uv:python3.12-bookworm

# Konteyner içinde çalışma dizini
WORKDIR /app

# 1) Proje metadata'sını kopyala (cache-friendly)
COPY pyproject.toml uv.lock* ./

# 2) Bağımlılıkları .venv içine kur (system değil)
#    --frozen: uv.lock'a birebir uyar
#    --no-dev: prod için dev bağımlılıkları alma (opsiyonel)
RUN uv sync --frozen --no-cache --no-dev

# .venv'yi PATH'e ekle ki uvicorn/fastapi bulunabilsin
ENV PATH="/app/.venv/bin:${PATH}"

# 3) Uygulama kodunu kopyala
COPY app ./app

# Cloud Run 8080 kullanır
ENV PORT=8080
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]
