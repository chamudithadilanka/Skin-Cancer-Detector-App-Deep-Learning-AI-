# 📱 Skin Cancer Detector AI App

> *AI-powered mobile assistant for preliminary skin lesion analysis*

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![TensorFlow](https://img.shields.io/badge/TensorFlow-FF6F00?style=for-the-badge&logo=tensorflow&logoColor=white)
![Flask](https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white)

---

## 🚀 Overview

This project is a **Skin Cancer Detection Mobile App** built with a modern tech stack:

| Layer | Technology |
|-------|-------------|
| 🧠 Deep Learning | CNN (TensorFlow / Keras) |
| ⚙️ Backend API | Flask |
| 📱 Mobile Frontend | Flutter |

### ✨ Features

- 📸 Upload or capture skin images
- 🔍 Get AI-based real-time predictions
- ⚠️ View risk level & detailed disease information

---

## 🧠 Supported Skin Conditions

The model detects **7 classes** of skin lesions:

| Class | Abbreviation | Description |
|-------|--------------|-------------|
| 🖤 | **mel** | Melanoma |
| 🟤 | **nv** | Melanocytic Nevi |
| 🔴 | **bcc** | Basal Cell Carcinoma |
| 🟠 | **akiec** | Actinic Keratoses |
| 🟡 | **bkl** | Benign Keratosis |
| ⚪ | **df** | Dermatofibroma |
| 🔵 | **vasc** | Vascular Lesions |

---

## 🏗️ Project Structure

```
Skin-Cancer-Detector/
│
├── backend/                 # Flask API
│   ├── app.py
│   ├── model/
│   └── disease_info.py
│
├── frontend/                # Flutter App
│   ├── lib/
│   └── assets/
│
├── model_training/          # Jupyter notebooks
└── README.md
```

---

## ⚙️ Installation Guide

### 🔹 1. Clone the Repository

```bash
git clone https://github.com/chamudithadilanka/Skin-Cancer-Detector-App-Deep-Learning-AI-.git
cd Skin-Cancer-Detector-App-Deep-Learning-AI-
```

### 🔹 2. Backend Setup (Flask)

#### ✅ Create Virtual Environment

```bash
python -m venv venv
```

#### ✅ Activate Environment

| OS | Command |
|----|---------|
| Windows | `venv\Scripts\activate` |
| Mac/Linux | `source venv/bin/activate` |

#### ✅ Install Requirements

```bash
pip install -r requirements.txt
```

#### ✅ Run Server

```bash
python app.py
```

🌐 Server will run on: `http://127.0.0.1:5000`

### 🔹 3. Frontend Setup (Flutter)

#### ✅ Install Flutter

Download from: [https://flutter.dev](https://flutter.dev)

#### ✅ Get Dependencies

```bash
flutter pub get
```

#### ✅ Run App

```bash
flutter run
```

---

### 🔗 Connect Flutter to API Config File

Replace local URL in your Flutter code:

```dart
// Before
const String apiUrl = "http://127.0.0.1:5000";

// After
const String apiUrl = "https://your-app.onrender.com";
```

---

## 🧪 Example API Request

**Endpoint:** `POST /predict`

### Using cURL

```bash
curl -X POST -F "file=@image.jpg" http://127.0.0.1:5000/predict
```

### Sample Response

```json
{
  "success": true,
  "prediction": {
    "class_key": "mel",
    "name": "Melanoma",
    "confidence": 68.7,
    "risk": "high",
    "risk_color": "red",
    "risk_label": "HIGH RISK — Urgent medical attention needed"
  },
  "top3": [
    {
      "class_key": "mel",
      "name": "Melanoma",
      "confidence": 68.7
    },
    {
      "class_key": "bkl",
      "name": "Benign Keratosis",
      "confidence": 29.0
    },
    {
      "class_key": "nv",
      "name": "Melanocytic Nevi",
      "confidence": 1.8
    }
  ],
  "disease_info": {
    "what_is_it": "Melanoma is the most dangerous form of skin cancer. It starts in the melanocytes — the cells that give skin its colour. It can spread to other organs if not caught early. Early detection gives a 98% survival rate. Late detection drops to 23%.",
    "symptoms": [
      "Asymmetrical mole — one half does not match the other",
      "Irregular, ragged, or blurred border",
      "Multiple colours in one lesion (brown, black, red, white, blue)",
      "Diameter larger than 6mm (bigger than a pencil eraser)",
      "Evolving — changing in size, shape, or colour over weeks",
      "Itching, bleeding, or crusting of an existing mole",
      "A new growth that looks different from your other moles"
    ],
    "home_care": [
      "Do NOT attempt any home treatment — this is serious",
      "Do not scratch, pick, or irritate the area",
      "Cover loosely with a clean bandage if it is bleeding",
      "Apply SPF 50+ sunscreen to surrounding skin daily",
      "Take clear photos of the lesion every 2–3 days to track changes",
      "Avoid all sun exposure on the affected area",
      "Write down when you first noticed it and any changes since"
    ],
    "treatments": [
      {
        "name": "Surgical excision",
        "type": "First-line treatment",
        "description": "The melanoma and surrounding tissue are surgically removed. This is the primary treatment for early-stage melanoma.",
        "done_by": "Dermatologist or surgeon"
      },
      {
        "name": "Sentinel lymph node biopsy",
        "type": "Staging procedure",
        "description": "Checks if the cancer has spread to nearby lymph nodes. Guides further treatment decisions.",
        "done_by": "Surgical oncologist"
      },
      {
        "name": "Immunotherapy",
        "type": "Advanced stage treatment",
        "description": "Drugs like pembrolizumab or nivolumab boost your immune system to fight cancer cells.",
        "done_by": "Oncologist"
      },
      {
        "name": "Targeted therapy",
        "type": "Advanced stage treatment",
        "description": "If BRAF mutation is present, drugs like vemurafenib target the specific mutation.",
        "done_by": "Oncologist"
      },
      {
        "name": "Radiation therapy",
        "type": "Supplementary treatment",
        "description": "Used when surgery is not possible or cancer has spread to brain or bones.",
        "done_by": "Radiation oncologist"
      }
    ]
  },
  "doctor_advice": {
    "urgency_level": "urgent",
    "urgency": "Book an appointment within 48–72 hours",
    "specialist": "Dermatologist → Surgical Oncologist",
    "what_to_say": "Tell the doctor: 'I have a changing mole that may be melanoma. I need an urgent skin biopsy.'",
    "tests_expect": [
      "Dermoscopy (magnified skin examination)",
      "Skin punch biopsy (tissue sample sent to lab)",
      "Full body skin check",
      "Lymph node ultrasound if biopsy confirms melanoma"
    ],
    "questions_to_ask": [
      "What stage is this melanoma?",
      "Has it spread to any lymph nodes?",
      "What are my treatment options?",
      "What are the survival statistics for my case?",
      "Do I need a referral to an oncologist?"
    ]
  },
  "emergency_signs": [
    "The lesion is actively bleeding and will not stop",
    "Rapid increase in size over days",
    "Severe pain in the affected area",
    "Swollen lymph nodes in armpit, groin, or neck",
    "Unexplained weight loss alongside the skin changes"
  ],
  "flags": {
    "see_doctor": true,
    "see_emergency": false
  },
  "disclaimer": "This app is for educational purposes only and is NOT a substitute for professional medical advice. Always consult a qualified dermatologist for proper diagnosis and treatment."
}
```

---

## 📊 Model Info

| Parameter | Value |
|-----------|-------|
| Architecture | CNN (TensorFlow / Keras) |
| Input Size | 224 × 224 pixels |
| Dataset | HAM10000 |
| Classes | 7 skin conditions |

---

## 📸 Screenshots

> *Add your app screenshots here*

| Home Screen | Prediction Result |
|-------------|-------------------|
| ![Home](link-to-your-screenshot) | ![Result](link-to-your-screenshot) |

---

## ⚠️ Disclaimer

> 🚨 **Educational Purpose Only**  
> This app is **NOT** a medical diagnosis tool. Always consult a qualified healthcare professional for any health concerns or before making any medical decisions.

---

## 🙌 Contribution

Contributions are welcome! Here's how you can help:

- 🎨 Improve UI/UX
- 🧠 Enhance model accuracy
- ✨ Add new features
- 🐛 Fix bugs

```bash
# Fork the repo, then:
git checkout -b feature/amazing-feature
git commit -m 'Add amazing feature'
git push origin feature/amazing-feature
```

---

## ⭐ Support

If you find this project useful:

| Action | Link |
|--------|------|
| ⭐ Star | `[Star]` button above |
| 🍴 Fork | `[Fork]` button |
| 📢 Share | Spread the word! |

---

## 📞 Contact 0763359921

**Created by Chamuditha Dilanka**

- GitHub: [@chamudithadilanka](https://github.com/chamudithadilanka)
- Project Link: [https://github.com/chamudithadilanka/Skin-Cancer-Detector-App-Deep-Learning-AI-](https://github.com/chamudithadilanka/Skin-Cancer-Detector-App-Deep-Learning-AI-)

---

## 📄 License

This project is open-source and available under the MIT License.

---

<div align="center">
  <sub>Built with ❤️ for better health awareness</sub>
</div>

---
