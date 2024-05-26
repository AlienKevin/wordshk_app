from collections import defaultdict
import json
import matplotlib.pyplot as plt


# Load the data from dict.json
with open('dict.json', 'r') as file:
    data = json.load(file)

syllable_counts = defaultdict(int)

for entry in data.values():
    variants = entry.get('variants', [])
    first_variant_prs = variants[0].get('p', '')
    first_pr = first_variant_prs[0]
    syllable_counts[len(first_pr)] += 1

print(syllable_counts)


# Create a bar chart for the syllable counts
syllable_numbers = list(syllable_counts.keys())
count_values = [syllable_counts[number] for number in syllable_numbers]

plt.figure(figsize=(10, 5))
bars = plt.bar(syllable_numbers, count_values, color='blue')

# Set font properties for Simplified Chinese using a common macOS Chinese font with increased font size
font_properties = {'fontname':'STHeiti', 'fontsize':14}

plt.xlabel('音节数量', **font_properties)
plt.ylabel('词条个数', **font_properties)
plt.title('词条音节数量分布', **font_properties)
plt.xticks(syllable_numbers)
plt.grid(axis='y', linestyle='--', alpha=0.7)

# Adding centered text labels on top of each bar with increased font size
for bar in bars:
    yval = bar.get_height()
    plt.text(bar.get_x() + bar.get_width()/2, yval, int(yval), ha='center', va='bottom', **font_properties)  # ha: horizontal alignment

plt.show()
