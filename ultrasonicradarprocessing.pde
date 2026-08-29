import processing.serial.*;

Serial myPort;

String data = "";
int iAngle = 0;
int iDistance = 0;

// Store latest detected distance for every angle
float[] detectedDistance = new float[181];

// Used to fade old detections
float[] detectionAlpha = new float[181];

void setup() {
  size(1200, 700);

  myPort = new Serial(this, "COM3", 9600);
  myPort.bufferUntil('.');

  for (int i = 0; i <= 180; i++) {
    detectedDistance[i] = -1;
    detectionAlpha[i] = 0;
  }
}

void draw() {
  background(20);

  drawRadar();
  drawObjects();
  drawSweep();
  drawInfo();

  // Slowly fade previous detections
  for (int i = 0; i <= 180; i++) {
    if (detectionAlpha[i] > 0) {
      detectionAlpha[i] -= 2;
    }
  }
}

void drawRadar() {

  pushMatrix();

  translate(width / 2, height - 70);

  stroke(40, 255, 40);
  strokeWeight(2);
  noFill();

  float radarRadius = 500;

  arc(0, 0, 1000, 1000, PI, TWO_PI);
  arc(0, 0, 750, 750, PI, TWO_PI);
  arc(0, 0, 500, 500, PI, TWO_PI);
  arc(0, 0, 250, 250, PI, TWO_PI);

  for (int angle = 0; angle <= 180; angle += 30) {

    float x = radarRadius * cos(radians(angle));
    float y = -radarRadius * sin(radians(angle));

    line(0, 0, x, y);
  }

  popMatrix();
}

void drawObjects() {

  pushMatrix();

  translate(width / 2, height - 70);

  float radarRadius = 500;

  for (int angle = 0; angle <= 180; angle++) {

    if (detectedDistance[angle] > 0 &&
        detectedDistance[angle] <= 40 &&
        detectionAlpha[angle] > 0) {

      float pixelDistance =
        map(detectedDistance[angle], 0, 40, 0, radarRadius);

      float startX =
        pixelDistance * cos(radians(angle));

      float startY =
        -pixelDistance * sin(radians(angle));

      float endX =
        radarRadius * cos(radians(angle));

      float endY =
        -radarRadius * sin(radians(angle));

      stroke(
        255,
        0,
        0,
        detectionAlpha[angle]
      );

      strokeWeight(3);

      line(
        startX,
        startY,
        endX,
        endY
      );
    }
  }

  popMatrix();
}

void drawSweep() {

  pushMatrix();

  translate(width / 2, height - 70);

  float radius = 500;

  for (int offset = 20; offset >= 0; offset--) {

    int angle = iAngle - offset;

    if (angle < 0 || angle > 180)
      continue;

    float alpha =
      map(offset, 20, 0, 20, 255);

    stroke(0, 255, 0, alpha);

    if (offset == 0)
      strokeWeight(5);
    else
      strokeWeight(2);

    float x =
      radius * cos(radians(angle));

    float y =
      -radius * sin(radians(angle));

    line(0, 0, x, y);
  }

  popMatrix();
}

void drawInfo() {

  noStroke();
  fill(10);

  rect(
    0,
    height - 60,
    width,
    60
  );

  fill(0, 255, 0);
  textSize(22);

  if (iDistance > 0 && iDistance <= 40) {
    text(
      "Object detected",
      30,
      height - 22
    );
  } else {
    text(
      "Object: Out of Range",
      30,
      height - 22
    );
  }

  text(
    "Angle: " + iAngle + "°",
    430,
    height - 22
  );

  text(
    "Distance: " + iDistance + " cm",
    700,
    height - 22
  );
}

void serialEvent(Serial myPort) {

  data = myPort.readStringUntil('.');

  if (data == null)
    return;

  data = trim(data);
  data = data.replace(".", "");

  int comma =
    data.indexOf(',');

  if (comma <= 0)
    return;

  String angleString =
    data.substring(0, comma);

  String distanceString =
    data.substring(comma + 1);

  iAngle =
    int(angleString);

  iDistance =
    int(distanceString);

  if (iAngle >= 0 && iAngle <= 180) {

    if (iDistance > 0 &&
        iDistance <= 40) {

      detectedDistance[iAngle] =
        iDistance;

      detectionAlpha[iAngle] =
        255;
    }
  }
}
