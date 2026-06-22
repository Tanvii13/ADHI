# ADHI — AI for Disability, Human Inclusion & Independence

[![Platform](https://img.shields.io/badge/Platform-Flutter%20Cross--Platform-blue.svg)]()
[![Backend](https://img.shields.io/badge/Backend-FastAPI%20+%20Gemini-orange.svg)]()
[![License](https://img.shields.io/badge/License-MIT-green.svg)]()

> *"Accessibility is not a privilege; it is a right."*

ADHI is an intelligent, multimodal AI accessibility platform engineered to consolidate separate assistive utilities into a single, cohesive, software-first ecosystem[cite: 1]. Dedicated to the vision of empowering individuals with visual, hearing, and speech impairments, ADHI leverages generative cloud processing and computer vision frameworks to give **Sight to the Blind**, **Ears to the Deaf**, and a **Voice to the Non-Verbal**[cite: 1].

---

## 📖 Table of Contents
1. [Core Modules & Features](#-core-modules--features)
2. [Tech Stack & Architecture](#-tech-stack--architecture)
3. [Repository File Structure](#-repository-file-tree)
4. [Backend API Specifications](#-backend-api-specifications)
5. [Local Deployment Guide](#-local-deployment-guide)

---

## 🌟 Core Modules & Features

### 👁️ Vision Assistant (Visual Mapping & Reading)
* **Contextual Scene Description:** Ingests live environmental viewpoints or captured frames through high-level vision reasoning APIs to return real-time descriptive textual and spoken analysis[cite: 1].
* **Spatial Object Detection:** Maps surrounding physical objects onto localized coordinates to pinpoint obstacle placements and increase indoor navigation safety[cite: 1].
* **Scene OCR Document Reader:** Leverages optical character text extraction pipelines to parse real-world signage, grocery labels, printed text, and documents immediately[cite: 1].

### 👂 Hearing Assistant (Auditory Translation & Alerts)
* **Live Environmental Captioning:** Pipelines raw spoken microphone stream buffers directly into low-latency automatic speech transcription processors to write real-time legible text[cite: 1].
* **Ambient Hazard Fingerprinting:** Actively filters the local sound stage to catch, flag, and alert users to critical safety trigger noises like Sirens, Smoke Alarms, Shouting, Knocking, and Doorbells[cite: 1].

### 🗣️ Voice Assistant (Vocal Synthesis Engine)
* **Custom Text-to-Speech Hub:** Translates user-typed text arrays into high-fidelity synthetic voice playback with scalable tone adjustments[cite: 1].
* **Tactile Phrase Macro Grid:** Offers a high-visibility panel populated with immediate touch-and-speak macro cards for vital everyday messages like *"Yes"*, *"No"*, *"Thank you"*, and *"I need help"*[cite: 1].

---

## 🏗️ Tech Stack & Architecture

* **Frontend Client:** Flutter SDK (Dart) deploying cross-platform targets optimized for deep font-scaling, text-readers, and high-readability color contrast[cite: 1].
* **Backend Framework:** Async FastAPI (Python) web gateway operating as the high-throughput gateway router[cite: 1].
* **Intelligence Layer:** Google Gemini Multimodal Processing pipelines blended with localized image and frequency processors[cite: 1].
* **Database & Hosting Infrastructure:** Firebase cross-platform distribution engines[cite: 1].
