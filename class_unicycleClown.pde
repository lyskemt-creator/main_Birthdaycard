class UnicycleClown {                              // Clown that moves left/right and bounces off the edges
  float x, y;                                      // Position of the clown (center point)
  PImage img;                                      // Image to draw
  float scaleFactor;                               // Scale factor for drawing the image
  float speedX;                                    // Horizontal speed (sign decides direction)

  UnicycleClown(float x, float y, PImage img, float scaleFactor, float speedX) { // Constructor
    this.x = x;                                    // Store x
    this.y = y;                                    // Store y
    this.img = img;                                // Store image
    this.scaleFactor = scaleFactor;                // Store scale
    this.speedX = speedX;                          // Store speed
  }

  void update() {                                  // Update position each frame
    if (img == null) return;                       // Safety: if image missing, skip movement

    x += speedX;                                   // Move horizontally

    float halfWidth = img.width * scaleFactor * 0.5; // Half the drawn width (used for edge collision)

    if (x > width - halfWidth || x < halfWidth) {  // If the image would go outside the canvas
      speedX *= -1;                                // Reverse direction
    }
  }

  void display() {                                 // Draw the clown
    if (img == null) return;                       // Safety check

    pushMatrix();                                  // Save transform state
    translate(x, y);                               // Move to clown position
    scale(speedX > 0 ? 1 : -1, 1);                 // Face direction of movement by mirroring when moving left
    imageMode(CENTER);                             // Draw from center
    image(img, 0, 0, img.width * scaleFactor, img.height * scaleFactor); // Draw scaled image
    popMatrix();                                   // Restore transform state
  }
}
