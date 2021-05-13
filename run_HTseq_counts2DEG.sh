g1=$1
g2=$2
outfile="docs/DESeq2_${g1}-${g2}.DEG_report.html"
Rscript -e "library(rmarkdown);rmarkdown::render(
input=\"HTseq_counts2DEG.Rmd\",
output_format=\"html_document\",
output_file=\"$outfile\",
params=list(condition1=\"$g1\",condition2=\"$g2\"))"
mv DESeq2_DEG_${g1}-${g2}_cpmfilter_1.txt results

