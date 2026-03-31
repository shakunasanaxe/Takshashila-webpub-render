FROM python:3.11-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies + TeX Live (more reliable than TinyTeX in Docker)
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    curl \
    gdebi-core \
    perl \
    ca-certificates \
    libglib2.0-0 \
    libfontconfig1 \
    libfreetype6 \
    libpng-dev \
    libjpeg-dev \
    texlive-xetex \
    texlive-fonts-recommended \
    texlive-plain-generic \
    texlive-latex-extra \
    && rm -rf /var/lib/apt/lists/*

# Install Quarto CLI
ARG QUARTO_VERSION=1.5.57
RUN wget -q "https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb" \
    && gdebi --non-interactive "quarto-${QUARTO_VERSION}-linux-amd64.deb" \
    && rm "quarto-${QUARTO_VERSION}-linux-amd64.deb"

# Python app
WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

WORKDIR /app/app

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
