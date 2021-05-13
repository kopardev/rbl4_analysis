library("tidyverse")

read_DESeq2_results<-function(resultsfile){
  results=read.csv(resultsfile,header = TRUE,sep="\t")
  results=results %>% unite("Gene",c("EnsemblID", "GeneName"),sep="|") %>% select(c("Gene","log2FoldChange","padj"))
  contrast=unlist(strsplit(unlist(strsplit(basename(resultsfile),"_DEG_"))[2],"_cpmfilter"))[1]
  colnames(results)=c("Gene",paste(contrast,"log2FC",sep="_"),paste(contrast,"padj",sep="_"))
  return(results)
}
merge_results<-function(r1,r2){
  return(merge(r1,r2,by=c("Gene"),all = TRUE))
}

files=list.files(path="./results",pattern = glob2rx("*_DEG_*txt"),full.names = TRUE)
results=list()
count=0
for (f in files){
  count=count+1
  results[[count]]=read_DESeq2_results(f)
}
m=reduce(results,merge_results)
# replace NAs with 1
x=list();for (i in colnames(m)){x[i]=1}
m=m %>% replace_na(x) %>% separate(col="Gene",into=c("EnsemblID","GeneName"),sep="\\|")

write.table(m,file = "results/combined_DESeq2_DEG_results.txt",col.names = TRUE,row.names = FALSE,quote = FALSE,sep = "\t")
