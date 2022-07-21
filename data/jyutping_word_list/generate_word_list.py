import json
import csv
import re
import opencc

variants = set()

# get words already in words.hk
with open('../../assets/api.json') as file:
  dict = json.load(file)["dict"]
  for _, value in dict.items():
    for variant in value["v"]:
      variants.add(variant["w"])
  print(variants)

# filter out words already in words.hk
filtered = None
input_filename = "word_list.tsv"
output_filename = "../../assets/word_list.tsv"
hk_converter = opencc.OpenCC('t2hk.json')
simp_converter = opencc.OpenCC('t2s.json')

def converter(row):
    word = row[0]
    hk_word = re.sub(r'[，：]', '', hk_converter.convert(word))
    simp_word = re.sub(r'[，：]', '', simp_converter.convert(word))
    return [hk_word, simp_word, row[1]]

with open(input_filename, 'r') as f_read:
    reader = csv.reader(f_read, delimiter='\t')
    filtered = map(converter,
        filter(lambda row: not (row[0] in variants) and len(row[0]) <= 9, reader)
    )
    with open(output_filename,'w') as f_write:
        csv.writer(f_write,delimiter='\t').writerows(filtered)
