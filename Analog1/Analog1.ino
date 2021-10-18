byte b;

void setup() {
  Serial.begin(1200);
  //pinMode(A0,INPUT); //connected to D7
  pinMode(12,OUTPUT); //Red
  pinMode(13,OUTPUT); //Green
}
int sig;
void loop() {
  sig=analogRead(A0);
  Serial.println(sig);
  if (Serial.available() > 0)
  {
    b = Serial.read();
    if(b){
      digitalWrite(12, LOW);
      digitalWrite(13, HIGH);
      
    }
    else{
      digitalWrite(13, LOW);
      digitalWrite(12,HIGH);
      }
  }
  
  }
