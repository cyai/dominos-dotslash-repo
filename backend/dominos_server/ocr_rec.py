import os
import tempfile
from PIL import Image
from paddleocr import PaddleOCR
import base64
import io

ocr = PaddleOCR(lang="en")

def decode_base64_image(base64_string):
    """Decodes a base64 string into a PIL Image after adding necessary padding."""
    if base64_string.startswith("data:image"):
        base64_string = base64_string.split(",")[1]

    base64_string = base64_string.strip()
    missing_padding = len(base64_string) % 4
    if missing_padding:
        base64_string += "=" * (4 - missing_padding)

    image_bytes = base64.b64decode(base64_string)

    return Image.open(io.BytesIO(image_bytes))


def perform_ocr(image_data):
    try:
        # Decode the base64 image
        image = decode_base64_image(image_data)

        image.save("debug_image.png")
        print("Image saved as debug_image.png")

        # Create a temporary directory
        with tempfile.TemporaryDirectory() as temp_dir:
            temp_file_path = os.path.join(temp_dir, "temp_image.png")

            image.save(temp_file_path)

            result = ocr.ocr(temp_file_path, det=True, cls=False)

        # Extract and return only the recognized labels
        if result == None:
            return {"ocr_results": ""}
        ocr_text = [res[1][0] for block in result for res in block]
        return {"ocr_results": ocr_text}

    except Exception as e:
        print(f"OCR Error: {e}")
        return {"error": f"Failed to process image: {e}"}, 500