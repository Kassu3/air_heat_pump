#include <WiFi.h>
#include <WebServer.h>
#include <ArduinoJson.h>
#include "config.h"

WebServer server(80);

// Midean tilamuuttujat
float currentTemperature = 22.5;
float targetTemperature = 22.0;
int insideHumidity = 49;
float powerConsumptionKW = 1.2;
bool sensorError = false;

// Ohjausmuuttujat
bool powerOn = true;
bool ecoMode = false;
String currentMode = "HEAT";    // AUTO, COOL, DRY, HEAT, FAN
String fanSpeed = "AUTO";       // SILENT, LOW, HIGH, AUTO
String swingDirection = "AUTO"; // UP, MIDDLE, DOWN, SWING

unsigned long lastSimUpdate = 0;

void sendCorsHeaders()
{
  server.sendHeader("Acces-Control-Allow-Origin", "*");
  server.sendHeader("Acces-Control-Allow-Methods", "GET, POST, OPTIONS");
  server.sendHeader("Acces-Control-Allow-Headers", "Content-Type");
}

void handleOptions()
{
  sendCorsHeaders();
  server.send(204);
}

void handleGetStatus()
{
  sendCorsHeaders();
  StaticJsonDocument<512> doc;
  doc["currentTemperature"] = round(currentTemperature * 10.0) / 10.0;
  doc["targetTemperature"] = targetTemperature;
  doc["currentMode"] = currentMode;
  doc["insideHumidity"] = insideHumidity;
  doc["powerConsumption"] = round(powerConsumptionKW * 100.0) / 100.0;
  doc["sensorError"] = sensorError;
  doc["fanSpeed"] = fanSpeed;
  doc["swingDirection"] = swingDirection;
  doc["powerOn"] = powerOn;
  doc["ecoMode"] = ecoMode;

  String response;
  serializeJson(doc, response);
  server.send(200, "application/json", response);
}

void handleSetControl()
{
  sendCorsHeaders();
  if (!server.hasArg("plain"))
  {
    server.send(400, "text/plain", "Body missing");
    return;
  }

  String body = server.arg("plain");
  StaticJsonDocument<512> doc;
  DeserializationError error = deserializeJson(doc, body);

  if (error)
  {
    server.send(400, "text/plain", "JSON Error");
    return;
  }

  if (doc.containsKey("targetTemperature"))
    targetTemperature = doc["targetTemperature"];
  if (doc.containsKey("currentMode"))
    currentMode = doc["currentMode"].as<String>();
  if (doc.containsKey("fanSpeed"))
    fanSpeed = doc["fanSpeed"].as<String>();
  if (doc.containsKey("swingDirection"))
    swingDirection = doc["swingDirection"].as<String>();
  if (doc.containsKey("powerOn"))
    powerOn = doc["powerOn"].as<bool>();
  if (doc.containsKey("ecoMode"))
    ecoMode = doc["ecoMode"].as<bool>();

  Serial.println("Ohjauskomento vastaanotettu: " + body);
  server.send(200, "text/plain", "OK");
}

void updateDeviceSimulation()
{
  if (millis() - lastSimUpdate < 3000)
    return;
  lastSimUpdate = millis();

  if (!powerOn)
  {
    powerConsumptionKW = 0.05; // Valmiustilan kulutus
    return;
  }

  // Lämpötila lähestyy tavoitetta asteittain
  if (currentTemperature < targetTemperature - 0.1)
  {
    currentTemperature += 0.2;
  }
  else if (currentTemperature > targetTemperature + 0.1)
  {
    currentTemperature -= 0.2;
  }

  // Kulutus riippuu lämpötilaerosta ja ECO-tilasta
  float diff = abs(targetTemperature - currentTemperature);
  float baseLoad = 0.6 + (diff * 0.35);
  powerConsumptionKW = ecoMode ? baseLoad * 0.75 : baseLoad;
}

void setup()
{
  Serial.begin(115200);
  WiFi.softAP(ssid, password);

  Serial.print("WiFi AP käynnistetty. IP-osoite: ");
  Serial.println(WiFi.softAPIP());

  server.on("/api/status", HTTP_GET, handleGetStatus);
  server.on("/api/status", HTTP_OPTIONS, handleOptions);
  server.on("/api/control", HTTP_POST, handleSetControl);
  server.on("/api/control", HTTP_OPTIONS, handleOptions);
  server.begin();
}

void loop()
{
  server.handleClient();
  updateDeviceSimulation();
}
