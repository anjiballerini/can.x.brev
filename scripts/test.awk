BEGIN { FS = ":"; }

((NR % 4) == 1) { barcodes[$10]++; }

END {
  for (bc in barcodes) {
            print bc": "barcodes[bc]"";
    }
}