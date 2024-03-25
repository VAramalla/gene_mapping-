awk '/^>/ {if (seqlen) {total += seqlen; count++}; seqlen=0; next} {seqlen += length($0)} END {total += seqlen; count++; print total/count}' NC_000913.faa
