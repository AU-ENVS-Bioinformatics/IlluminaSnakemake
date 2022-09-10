from Bio import SeqIO
import re

MINIMUN_16S_SEQUENCE_LENGTH_ALLOWED = int(snakemake.params[0])
input_fasta = snakemake.input[0]
output_fasta = snakemake.output[0]
input_gff = snakemake.input[1]
output_gff = snakemake.output[1]

def is_valid_16s_record(record) -> bool:
    is_16s = re.search("16S_rRNA", record.id)
    is_long_enough = len(record.seq) > MINIMUN_16S_SEQUENCE_LENGTH_ALLOWED
    return(all([is_16s, is_long_enough]))

def parse_fasta_into_gff_id(name: str) -> str:
    return(name.split(':')[2])

fasta_ids = list()
with open(output_fasta, 'w') as filtered_fasta, open(input_fasta) as input_fasta:
    for record in SeqIO.parse(input_fasta, "fasta"):
        if is_valid_16s_record(record):
            SeqIO.write(record, filtered_fasta, "fasta")
            fasta_ids.append(record.id)

gff_ids = [parse_fasta_into_gff_id(fasta_id) for fasta_id in fasta_ids]

with open(output_gff, 'w') as filtered_gff, open(input_gff) as input_gff:
    filtered_gff.write('##gff-version 3\n')
    for line in input_gff:
        print(line)
        print()
        if any(gff_id in line for gff_id in gff_ids):
            filtered_gff.write(f"{line}\n")