from flask import Flask, request, jsonify
import tensorflow as tf
import numpy as np
import json
from PIL import Image
import io

app = Flask(__name__)

# ── Load model + class map once at startup ───────────────────
print("Loading model...")
model = tf.keras.models.load_model('mob_best.h5')

with open('class_indices.json') as f:
    class_indices = json.load(f)
idx_to_class = {v: k for k, v in class_indices.items()}
print(f"Ready. Classes: {list(class_indices.keys())}")

from disease_info import DISEASE_INFO


def preprocess(image_bytes):
    img = Image.open(io.BytesIO(image_bytes)).convert('RGB')
    img = img.resize((224, 224), Image.LANCZOS)
    arr = np.array(img, dtype=np.float32) / 255.0
    return np.expand_dims(arr, axis=0)


@app.route("/", methods=["GET"])
def home():
    return jsonify({
        "message": "Skin Disease Detection API is running",
        "health": "/health",
        "predict": "/predict"
    })


@app.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'ok'})


@app.route('/predict', methods=['POST'])
def predict():
    if 'image' not in request.files:
        return jsonify({'error': 'No image provided'}), 400

    try:
        img_bytes = request.files['image'].read()
        tensor    = preprocess(img_bytes)
        probs     = model.predict(tensor, verbose=0)[0]

        top_idx    = int(np.argmax(probs))
        confidence = float(probs[top_idx])
        class_key  = idx_to_class[top_idx]
        info       = DISEASE_INFO[class_key]

        # Top 3 predictions
        top3 = [
            {
                'class_key':  idx_to_class[int(i)],
                'name':       DISEASE_INFO[idx_to_class[int(i)]]['name'],
                'confidence': round(float(probs[i]) * 100, 1),
            }
            for i in np.argsort(probs)[::-1][:3]
        ]

        return jsonify({
            'success': True,
            'prediction': {
                'class_key':  class_key,
                'name':       info['name'],
                'confidence': round(confidence * 100, 1),
                'risk':       info['risk'],
                'risk_color': info['risk_color'],
                'risk_label': info['risk_label'],
            },
            'top3': top3,
            'disease_info': {
                'what_is_it':  info['what_is_it'],
                'symptoms':    info['symptoms'],
                'home_care':   info['home_care'],
                'treatments':  info['treatments'],
            },
            'doctor_advice': {
                'specialist':       info['doctor_advice']['specialist'],
                'urgency':          info['doctor_advice']['urgency'],
                'urgency_level':    info['doctor_advice']['urgency_level'],
                'what_to_say':      info['doctor_advice']['what_to_say'],
                'tests_expect':     info['doctor_advice']['tests_expect'],
                'questions_to_ask': info['doctor_advice']['questions_to_ask'],
            },
            'emergency_signs': info['emergency_signs'],
            'flags': {
                'see_doctor':    info['see_doctor'],
                'see_emergency': info['see_emergency'],
            },
            'disclaimer': (
                'This app is for educational purposes only and is NOT a substitute '
                'for professional medical advice. Always consult a qualified '
                'dermatologist for proper diagnosis and treatment.'
            ),
        })

    except Exception as e:
        return jsonify({'error': str(e), 'success': False}), 500


# if __name__ == '__main__':
#     app.run(host='0.0.0.0', port=5000, debug=False)
import os

if __name__ == '__main__':
    port = int(os.environ.get("PORT", 5000))
    app.run(host='0.0.0.0', port=port)