Here's a beautifully formatted version of your **Skin Cancer Detector AI App** README, designed for clarity, visual appeal, and easy navigation.

---

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
git clone https://github.com/YOUR_USERNAME/Skin-Cancer-Detector.git
cd Skin-Cancer-Detector
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

## 🌍 Deploy Backend (FREE)

Make your API accessible globally:

| Platform | Link | Difficulty |
|----------|------|------------|
| 🚀 **Render** (Recommended) | [render.com](https://render.com) | Easy |
| 🚆 Railway | [railway.app](https://railway.app) | Easy |

### 📋 Render Deployment Steps

1. Push code to GitHub
2. Go to [render.com](https://render.com)
3. Create a **Web Service**
4. Connect your repo
5. Set:
   - **Build Command:** `pip install -r requirements.txt`
   - **Start Command:** `python app.py`

✅ You'll get: `https://your-app.onrender.com`

### 🔗 Connect Flutter to API

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
  "prediction": "nv",
  "confidence": 0.94,
  "risk_level": "Low",
  "description": "Melanocytic Nevi - Common mole, typically benign"
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

## 📞 Contact

**Created by Chamuditha Dilanka**

---

## 📄 License

This project is open-source and available under the MIT License.

---

<div align="center">
  <sub>Built with ❤️ for better health awareness</sub>
</div>
