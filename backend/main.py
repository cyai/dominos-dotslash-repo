from flask import Flask, request, jsonify
import json
import os
import sys

import importlib.util

relative_path = os.path.join(os.getcwd(), "dominos-server")
sys.path.append(relative_path)

ocr_rec = importlib.import_module("ocr_rec")
output_parser = importlib.import_module("output_parser")

from ocr_rec import perform_ocr
from output_parser import data_cleaner

app = Flask(__name__)


@app.route("/health", methods=["GET"])
def check_health():
    return "Healthy"

@app.route('/sample_data', methods = ["GET"])
def random_data():
    sample = jsonify({"heart": [0.5, "Sodium Nitrite", "Sulfur Dioxide"],
                    "stomach":[-0.2, "Potassium Sorbate", "Sodium Erythorbate"] ,
                    "kidney": [-0.3, "Potassium Sorbate", "Propyl Paraben"],
                    "skin" : [0.7, "Propionic Acid", "Propyl Paraben"]})
    
    return sample

@app.route("/processing", methods=["POST"])
def data_processing():
    try:
        if not request.data:
            return jsonify({"error": "No data received"}), 400

        base64_data = request.get_data()

        try:
            print(type(json.loads(base64_data)))
            ocr_data = perform_ocr(json.loads(base64_data)["base64_data"])
            clean_data = data_cleaner(str(ocr_data))
            # final_output = e

            return jsonify({"clean_data": clean_data}), 200

        except Exception as e:
            return jsonify({"error": str(e)}), 500

    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    app.run(port=5000, debug=True, host="0.0.0.0")
