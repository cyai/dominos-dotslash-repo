import os
from dotenv import load_dotenv
from openai import OpenAI
from pydantic import BaseModel
from typing import List
import json

import os

load_dotenv()

API_KEY = os.getenv("OPENAI_KEY")


client = OpenAI(
    api_key=API_KEY,
)


def data_cleaner(prompt_text):

    class IngredientsResponse(BaseModel):
        ingredients: List[str]

    response = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[
            {
                "role": "system",
                "content": "You are food specialist. I have the text scanned from the side of a product's ingredient list through a OCR model. But the text is jumbled together. I want you to now use that string and give me the systematic ingredients back. Dont add or delete any ingredient that is not in the given string. Give me the ",
            },
            {
                "role": "user",
                "content": f"Ingredients text from the OCR model: {prompt_text}",
            },
        ],
        functions=[
            {
                "name": "extract_ingredients",
                "description": "Extract ingredients systematically from a string and return as JSON. DO NOT add any ingredient that is not in the string.",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "ingredients": {
                            "type": "array",
                            "items": {"type": "string"},
                            "description": "List of ingredients extracted from the text.",
                        }
                    },
                    "required": ["ingredients"],
                },
            }
        ],
        function_call={"name": "extract_ingredients"},
    )
    message = response.choices[0].message.function_call.arguments

    try:
        json_data = json.loads(message)
        return json_data["ingredients"]

    except json.JSONDecodeError as e:
        return f"Failed to parse JSON: {e}"


result = data_cleaner(
    str(
        {
            "ocr_results": [
                "Allergen Advice: Contains Wheat, Milk, Soy and Nut.",
                "Papaya {Papaya CubesSugar Acidity Regulator INS 330}Cranberry]Nuts(4%Cashew Bits Almond Bits)",
                "Ingredients: Retined Wheat Flour Maida)Sugar Edible Vegetable Oil (Palm) Dry Fruits 8% [Black Curant",
                "Approximate values.%Calculated based on reference daily energy intake value ot 2000 kcal.",
                "Sodium 63mg",
                "Sodium 209mg",
                "ny Fat7kcal",
                "holesterol",
                "Creative Visualization",
            ]
        }
    )
)
print(result)
