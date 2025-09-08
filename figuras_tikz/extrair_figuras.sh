#!/bin/bash

# --- CONFIGURAÇÕES ---
PDF_ORIGINAL="figuras_tikz.pdf"   # PDF com todas as figuras TikZ
TEX_DIR="./"                       # Diretório dos arquivos .tex do projeto
OUTDIR="figuras_cortadas"          # Diretório de saída dos PDFs cortados
LABELS_FILE="labels.txt"           # Arquivo temporário com labels

mkdir -p "$OUTDIR"
> "$LABELS_FILE"  # limpa arquivo anterior

# --- 1. Extrair todos os labels do projeto ---
find "$TEX_DIR" -name "*.tex" -exec grep -rhoP '\\label\{\K[^\}]+(?=\})' {} \; >> "$LABELS_FILE"

echo "Labels extraídos:"
cat "$LABELS_FILE"

# --- 2. Separar páginas do PDF em PDFs temporários ---
TEMP_DIR=$(mktemp -d)
pdfseparate "$PDF_ORIGINAL" "$TEMP_DIR/figura_%03d.pdf"

# --- 3. Aplicar pdfcrop e renomear usando labels ---
i=0
while IFS= read -r label; do
    i=$((i+1))
    PAGE_FILE="$TEMP_DIR/figura_$(printf "%03d" $i).pdf"
    if [ -f "$PAGE_FILE" ]; then
        pdfcrop "$PAGE_FILE" "$OUTDIR/${label}.pdf"
    else
        echo "Aviso: Não existe página $i para o label $label"
    fi
done < "$LABELS_FILE"

# --- 4. Limpar arquivos temporários ---
rm -r "$TEMP_DIR"
rm "$LABELS_FILE"

echo "Extração concluída! PDFs cortados estão em '$OUTDIR' com nomes baseados nos labels."
