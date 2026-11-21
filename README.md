# Midea Smart AC – IoT Remote Control & ESP32 Firmware 

A modern, responsive IoT control system for remote management of a heat pump. The project consists of a **Flutter** mobile application and **ESP32 (PlatformIO)** microcontroller firmware communicating over a local network via an HTTP REST API. 

--- 

## Key Features 

### Mobile Application (`mi_smart_ac`) 
* **Neumorphic UI & Themes:** Soft UI (neumorphic) design supporting both **Dark Mode** and **Light Mode** using Material 3 `ColorScheme` and `ThemeExtension`. 
* **Interactive Thermostat:** Real-time target temperature control, indoor/outdoor temperature monitoring, and filter maintenance alerts. 
* **Operating Modes & ECO Power Limits:** Support for `AUTO`, `COOL`, `DRY`, `HEAT`, and `FAN` modes, fan speed and swing controls, plus multi-stage `ECO` power limits (75% and 50%). 
* **Localization:** Dynamic in-app translations (`AppTranslations`) supporting English, Finnish, Swedish, and German. 
* **Scheduling & Energy Monitoring:** Weekly smart schedules and hourly power consumption (kWh) visualization. 
* **Automatic Demo Mode (Fallback Simulation):** Seamlessly switches to a local simulation mode if the physical ESP32 device is unreachable. 

### Embedded Firmware (`Midea-ESP32`) 
* **Local Wi-Fi Access Point (`192.168.4.1`):** Establishes a direct wireless connection between the mobile app and the controller without cloud dependencies. 
* **HTTP REST API:** 
  * `GET /api/status` – Returns device state, temperatures, humidity, power consumption, and sensor error flags in JSON format. 
  * `POST /api/control` – Accepts control commands (target temperature, mode, fan speed, swing, power state, and ECO mode). 
* **Hardware-Level Simulation:** Built-in temperature and power consumption simulation for testing without physical HVAC hardware. 

--- 

## Architecture & API 

```text 
[ Flutter Mobile App ] <-- HTTP JSON (192.168.4.1) --> [ ESP32 Microcontroller ] 
  - UI & Neumorphism                                     - Wi-Fi SoftAP / WebServer 
  - Theme & Localization                                 - REST API (/api/status, /api/control) 
  - State Management                                     - Device & Sensor Simulation 
``` 

--- 

## Roadmap (Production Readiness) 

The current implementation serves as a complete full-stack IoT prototype. Planned next steps for physical hardware deployment: 

1. **Hardware Interface Integration:** Replace simulation logic with physical UART or IR communication (e.g., `MideaUART` or `IRremoteESP8266`). 
2. **Persistent Storage:** Store device configurations and schedules locally on the mobile device (`shared_preferences`) and in ESP32 non-volatile storage (`NVS`). 
3. **Hourly Consumption History:** Log historical energy data on the ESP32 and expose it via a dedicated endpoint (`GET /api/electricity/history`). 

--- 

## Getting Started 

### 1. ESP32 Firmware (PlatformIO) 
1. Copy `include/config.example.h` to `include/config.h` and configure your SoftAP credentials if needed. 
2. Build and upload the firmware: 
```bash 
cd Midea-ESP32 
pio run --target upload 
``` 

### 2. Flutter Application 
```bash 
cd mi_smart_ac 
flutter pub get 
flutter run 
``` 

--- 

## License & Copyright

Copyright (c) 2026 [Kassu3]. All Rights Reserved.

This project is published as a portfolio piece for job applications. Copying, modifying, or distributing the code, application, or assets without permission is prohibited.