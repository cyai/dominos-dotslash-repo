from flask import Flask, request, jsonify
import json
from dotenv import load_dotenv
import os


app = Flask(__name__)

@app.route('/processing', method = 'POST')
def data_processing():
    if not request.is_json:
        return jsonify({"No data from the backend"}), 400
    
    json_data = request.get_json

    try:
        return None

    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
if __name__ == "__main__":
    app.run(port = 5000, debug = True)