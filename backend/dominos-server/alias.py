from alias_table import alias_table
# for normalising input and reverse lookups in searching, less time complexity as well
reverse_alias = {}

for key, aliases in alias_table.items():
    for alias in aliases:
        reverse_alias[alias.lower()] = key


listt = [
    ""
]


listt = [i.lower() for i in listt]
# print(listt)

for scan in listt:
    if scan in reverse_alias:
        name = reverse_alias[scan]
        print(f"Alias matched ! {name}")
    else:
        print(f"No match found in alias table")


