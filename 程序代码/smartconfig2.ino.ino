#include <ESP8266WiFi.h>;

void setup() {
  Serial.begin(115200);
  delay(10);

  // 必须采用 AP 与 Station 兼容模式
  WiFi.mode(WIFI_AP_STA);
  delay(500);


 // 等待配网
  WiFi.beginSmartConfig();

 // 收到配网信息后ESP8266将自动连接，WiFi.status 状态就会返回：已连接
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
    // 完成连接，退出配网等待。
    Serial.println(WiFi.smartConfigDone());
  }

  Serial.println("");
  Serial.println("WiFi connected");  
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

int value = 0;

void loop() {
}
