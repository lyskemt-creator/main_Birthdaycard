class Confetti {                              // Single confetti particle that falls downward and respawns at top
  float x, y;                                 // Position
  float s;                                 // Circle size
  float speed;                                // Falling speed
  color c;                                    // Color

  Confetti() {                                // Constructor
    reset();                                  // Initialize particle with random values
  }

  void reset() {                              // Put particle back to a random start position
    x = random(width);                        // Random x across canvas
    y = random(-height, 0);                   // Random y above the top (so it falls in naturally)
    s = random(4, 10);                     // Random size
    speed = random(1, 3);                     // Random fall speed
    c = color(random(255), random(255), random(255)); // Random RGB color
  }

  void update() {                             // Move particle each frame
    y += speed;                               // Move down
    if (y > height) reset();                  // If it leaves the bottom, respawn above
  }

  void display() {                            // Draw particle
    noStroke();                               // No outline
    fill(c);                                  // Set fill color
    ellipse(x, y, s, s);                // Draw circle
  }
}
