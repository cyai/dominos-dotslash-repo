from dominos_server import alias_table
from rapidfuzz import fuzz
from dominos_server.alias_table import alias_table
import pandas as pd
import numpy as np


def calculate_normalized_scores(matched_ingredients):

    data = pd.read_json('dominos_server/ingredients.json')
    h, s, k, sk = 0, 0, 0, 0
    ht = []
    st = []
    ki = []
    ski = []
    for val in matched_ingredients:
        for ingredients in data['ingredients']:
            if ingredients['name'] == val[0]:
                # h += ingredients['heart_weight']
                ht.append((ingredients['heart_weight'], ingredients["name"]))
                # s += ingredients['stomach_weight']
                st.append((ingredients['stomach_weight'], ingredients["name"]))
                # k += ingredients['kidney_weight']
                ki.append((ingredients['kidney_weight'], ingredients["name"]))
                # sk += ingredients['skin_weight']
                ski.append((ingredients['skin_weight'], ingredients["name"]))
                
    organs = [ht, st, ki, ski]
    # organ_score = [h, s, k, sk]
    normalised_score = []
    best_worst = []
    for organ in organs:
        best = max(organ, key=lambda x: x[0]) 
        worst = min(organ, key=lambda x: x[0])
        best_worst.append([best, worst])
        
        mean = np.mean([abs(num[0]) for num in organ])
        normalised_score.append(mean)

    return normalised_score, best_worst
    
def getting_match(sample_list):
    final_vals=[]
    for sample in sample_list:
        for ing, alias in alias_table.items():
            if fuzz.ratio(sample.lower(), ing.lower()) >= 70:
                final_vals.append([ing, sample])  # Add the matched key
                break  # Stop checking once a match is found
            for i in alias:  # Check aliases if no match found for key
                if fuzz.ratio(sample.lower(), i.lower()) >= 70:
                    final_vals.append([ing, sample])  # Add the matched key (not alias)
                    break
            else:
                continue 
            break

    return calculate_normalized_scores(final_vals)



    




    

