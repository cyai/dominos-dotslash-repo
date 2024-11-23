import os
from dotenv import load_dotenv
from openai import OpenAI
from pydantic import BaseModel
from typing import List
import json

import os
load_dotenv()

API_KEY = os.getenv('OPENAI_KEY')


client = OpenAI(
    api_key=API_KEY,  
)

def data_cleaner(prompt_text):

    class IngredientsResponse(BaseModel):
        ingredients: List[str]

    response = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[
            {"role": "system", "content": "You are a helpful assistant. Extract the ingredients list as a JSON object."},
            {"role": "user", "content": prompt_text}
        ],
        functions=[
            {
                "name": "extract_ingredients",
                "description": "Extract ingredients from a string and return as JSON.",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "ingredients": {
                            "type": "array",
                            "items": {"type": "string"},
                            "description": "List of ingredients extracted from the text."
                        }
                    },
                    "required": ["ingredients"]
                }
            }
        ],
        function_call={"name": "extract_ingredients"}
    )
    message = response.choices[0].message.function_call.arguments

    try:
        json_data = json.loads(message)  
        return json_data['ingredients']
      
    except json.JSONDecodeError as e:
        return f"Failed to parse JSON: {e}"

