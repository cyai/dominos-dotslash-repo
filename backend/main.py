from flask import Flask, request, jsonify
import json
import os
import sys

import importlib.util
from dominos_server.ocr_rec import perform_ocr
from dominos_server.output_parser import data_cleaner
from dominos_server.report import getting_match

app = Flask(__name__)


@app.route("/health", methods=["GET"])
def check_health():
    return "Healthy"


@app.route("/sample_data", methods=["GET"])
def random_data():
    sample = jsonify(
        {
            "heart": [0.5, "Sodium Nitrite", "Sulfur Dioxide"],
            "stomach": [-0.2, "Potassium Sorbate", "Sodium Erythorbate"],
            "kidney": [-0.3, "Potassium Sorbate", "Propyl Paraben"],
            "skin": [0.7, "Propionic Acid", "Propyl Paraben"],
        }
    )

    return sample


@app.route("/processing", methods=["POST"])
def data_processing():
    try:
        if not request.data:
            return jsonify({"error": "No data received"}), 400

        base64_data = request.get_data()

        try:
            print("Getting ocr...")
            ocr_data = perform_ocr(json.loads(base64_data)["base64_data"])
            # print(len(ocr_data["ocr_results"]))
            if len(ocr_data["ocr_results"]) == 0:
                response_payload = {
                    "heart": [-1, "N/A", "N/A"],
                    "skin": [-1, "N/A", "N/A"],
                    "kidney": [-1, "N/A", "N/A"],
                    "stomach": [-1, "N/A", "N/A"],
                }
                return response_payload, 200

            print(f"OCR data: {ocr_data}")
            print("parsing the OCR text...")
            clean_data = data_cleaner(str(ocr_data))
            print(f"Clean result: {clean_data}")
            print("getting report...")
            normalized_scores, best_work_match = getting_match(list(clean_data))

            response_payload = {
                "heart": [
                    normalized_scores[0],
                    best_work_match[0][0][1],
                    best_work_match[0][1][1],
                ],
                "skin": [
                    normalized_scores[1],
                    best_work_match[1][0][1],
                    best_work_match[1][1][1],
                ],
                "kidney": [
                    normalized_scores[2],
                    best_work_match[2][0][1],
                    best_work_match[2][1][1],
                ],
                "stomach": [
                    normalized_scores[3],
                    best_work_match[3][0][1],
                    best_work_match[3][1][1],
                ],
            }

            return response_payload, 200

        except Exception as e:
            print(f"Error while processing: {e}")
            return jsonify({"error": str(e)}), 500

    except Exception as e:
        print("Error while processing: ", e)
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    app.run(port=5001, debug=True, host="0.0.0.0")
