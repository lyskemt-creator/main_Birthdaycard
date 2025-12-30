class DancingClown {                                            // Clown that bounces, rotates, and flips at the bottom
  float x, y;                                                   // Base position (center point)
  PImage img;                                                   // Image to draw

  float scaleFactor;                                            // Scale factor for drawing the image
  float amplitude;                                              // How far up/down it moves
  float rotationAmplitude;                                      // How much it rotates left/right

  float time = 0;                                               // Time counter for sine animation
  float phase;                                                  // Random phase so motion feels more alive

  boolean mirrored = false;                                     // If true, we draw image mirrored horizontally
  boolean bottomLock = false;                                   // Prevent flipping multiple times during one bottom pass

  DancingClown(float x, float y, PImage img,
               float scaleFactor, float amplitude, float rotationAmplitude) { // Constructor
    this.x = x;                                                 // Store base x
    this.y = y;                                                 // Store base y
    this.img = img;                                             // Store image reference
    this.scaleFactor = scaleFactor;                             // Store scale
    this.amplitude = amplitude;                                 // Store amplitude
    this.rotationAmplitude = rotationAmplitude;                 // Store rotation amplitude
    phase = random(TWO_PI);                                     // Random starting phase so animation is not repetitive
  }

  void update() {                                               // Update called each frame
    time += 0.05;                                               // Increase time so sine waves change over time
  }

  void display() {                                              // Draw the clown each frame
    if (img == null) return;                                    // Safety: if image failed to load, do nothing

    float verticalOffset = sin(time + phase) * amplitude;       // Compute up/down movement using sine
    float rotation = sin(time * 1.3 + phase) * rotationAmplitude; // Compute rotation using another sine

    if (!bottomLock && verticalOffset < -0.8 * amplitude) {     // If near the bottom of motion and not locked
      mirrored = !mirrored;                                     // Flip the direction once
      bottomLock = true;                                        // Lock so it doesn't flip repeatedly
    }

    if (verticalOffset > -0.4 * amplitude) {                    // When it rises again enough
      bottomLock = false;                                       // Unlock so next bottom can flip again
    }

    pushMatrix();                                               // Save current transform state
    translate(x, y + verticalOffset);                           // Move to base position plus bounce offset
    rotate(rotation);                                           // Apply rotation
    scale(mirrored ? -1 : 1, 1);                                // Mirror horizontally if needed
    imageMode(CENTER);                                          // Draw image from its center
    image(img, 0, 0, img.width * scaleFactor, img.height * scaleFactor); // Draw scaled image at local origin
    popMatrix();                                                // Restore transform state
  }
}
