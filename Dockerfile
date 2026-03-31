FROM python:3.11-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies + TeX Live
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    curl \
    unzip \
    gdebi-core \
    perl \
    ca-certificates \
    fontconfig \
    libglib2.0-0 \
    libfontconfig1 \
    libfreetype6 \
    libpng-dev \
    libjpeg-dev \
    texlive-xetex \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    texlive-plain-generic \
    texlive-latex-extra \
    texlive-bibtex-extra \
    biber \
    lmodern \
    fonts-texgyre \
    && rm -rf /var/lib/apt/lists/*

# Install Inter font (required by pdf-template.tex)
RUN wget -q "https://github.com/rsms/inter/releases/download/v4.0/Inter-4.0.zip" \
    && unzip -q Inter-4.0.zip -d /tmp/inter \
    && find /tmp/inter -name "*.ttf" -exec cp {} /usr/local/share/fonts/ \; \
    && fc-cache -f \
    && rm -rf Inter-4.0.zip /tmp/inter

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
