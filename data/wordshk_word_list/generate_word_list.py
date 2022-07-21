import json
from ordered_set import OrderedSet

words = OrderedSet()

# get words already in words.hk
with open('../../assets/api.json') as file:
  dict = json.load(file)["dict"]
  print("Number of unique words in words.hk: {}".format(len(dict)))
  for _, value in dict.items():
    for variant in value["v"]:
      words.add(variant["w"])
  with open("word_list.txt", "w") as list_file:
    list_file.write("\n".join(words))
