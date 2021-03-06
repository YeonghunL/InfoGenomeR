#!/bin/bash
reference=hg19.fa
norm_script=./NBICseq-norm_v0.2.4/NBICseq-norm.pl
map_file=./NBICseq-norm_v0.2.4/hg19.CRG.50bp/
read_length=100
fragment_size=350
tumor_bam=tumor.bam

mkdir bicseq_samtools
modifiedSamtools view -U BWA,bicseq_samtools/,N,N $tumor_bam

mkdir cn_norm
echo -e "chromName\tfaFile\tMapFile\treadPosFile\tbinFileNorm" > norm_configFile;
for i in {1..23}
do
        if [ $i == 23 ]
        then
                chr="X";
        else
                chr=$i;
        fi
        echo -e "$chr\t$reference.$chr\t$map_file\/hg19.50mer.CRC.chr$chr.txt\t$PWD/bicseq_samtools/$chr.seq\t$PWD/cn_norm/$chr.norm.bin" >> norm_configFile;

done

mkdir tmp;
perl $norm_script -l $read_length -s $fragment_size norm_configFile ./NB_parameters --tmp tmp

