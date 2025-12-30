class Ticket {                                     // Ticket that becomes active after a delay and slides upward
  PImage img;                                      // Ticket image
  float x, y;                                      // Current ticket position
  float targetY;                                   // Y position where ticket should stop
  float speed;                                     // Upward movement speed
  float scaleFactor = 0.5;                         // Scale factor for drawing the ticket

  boolean active = false;                          // False until delay is over
  boolean arrived = false;                         // True once it reached targetY

  int startTime;                                   // Time when delay started (millis)
  int delay;                                       // Delay length in ms

  Ticket(PImage img, float x, float targetY, float speed) { // Constructor
    this.img = img;                                // Store image
    this.x = x;                                    // Store x
    this.targetY = targetY;                        // Store targetY
    this.speed = speed;                            // Store speed
    y = height + 300;                              // Start off-screen below the canvas
  }

  void startAfterDelay(int delay) {                // Prepare ticket to start moving after delay
    this.delay = delay;                            // Store delay length
    startTime = millis();                          // Record current time
    active = false;                                // Reset active state
    arrived = false;                               // Reset arrived state
    y = height + 300;                              // Reset starting position below screen
  }

  void update() {                                  // Update ticket each frame
    if (!active) {                                 // If not yet active
      if (millis() - startTime >= delay) active = true; // Activate after delay has passed
      else return;                                 // If delay not done, stop here
    }

    if (arrived) return;                           // If already at target, stop moving

    y -= speed;                                    // Move upward (smaller y is higher)
    if (y <= targetY) {                            // If we passed the target
      y = targetY;                                 // Clamp to targetY
      arrived = true;                              // Mark as arrived
    }
  }

  void display() {                                 // Draw ticket
    if (!active || img == null) return;            // Only draw if active and image exists

    imageMode(CENTER);                             // Draw from center
    image(img, x, y, img.width * scaleFactor, img.height * scaleFactor); // Draw scaled ticket image
  }
}
