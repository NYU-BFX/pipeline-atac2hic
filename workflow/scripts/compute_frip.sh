#!/bin/bash
set -e

# Tn5="$1"
# PEAKS="$2"
# OUT="$3"
Tn5="${snakemake_input[tn5]}"
PEAKS="${snakemake_input[peaks]}"
OUT="${snakemake_output[0]}"
sample_id="${snakemake_wildcards[srr]}"

read_counts=$(wc -l < "$Tn5")
peak_counts=$(wc -l < "$PEAKS")
peak_length=$(awk -F'\t' '{sum += ($3 - $2)} END {print sum}' "$PEAKS")
reads_in_peaks=$(sort -k1,1 -k2,2n "$PEAKS" | bedtools intersect -u -a "$Tn5" -b - -sorted | wc -l)
frip=$(bc -l <<< "${reads_in_peaks}/${read_counts}")
# sample_id=$(basename "$Tn5")
# sample_id=${sample_id%_Tn5_slop20_blacklisted.bed}
echo -e "$sample_id"\\t"$peak_counts"\\t"$peak_length"\\t"$read_counts"\\t"$reads_in_peaks"\\t"$frip" > "$OUT"
