from rapidfuzz import process
from alias_table import alias_table
from alias import scanned_label, reverse_alias

# extracting all the keys from alias_table and putting it in the list called name

name = list(alias_table.keys())

if scanned_label not in reverse_alias:
    match, simi_score, _ = process.extractOne(scanned_label, name)
    if simi_score > 80:
        name = match
        print(f"Fuzzy matched ! {name}")
    else:
        print(f"No match found")

# implement fuzzy in parallel recog of ingredients 
# implement extraction of weights and summing and normalising and outputting the result
# need to display best and worst ingredient for each organ as well