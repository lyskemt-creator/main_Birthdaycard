class PlayButton {                               // A clickable play button that fades out when clicked
  float x, y, d;                                 // x/y position and diameter
  float opacity = 255;                           // Current alpha value (255 = visible)
  boolean fading = false;                        // True when we start fading
  boolean fadedOut = false;                      // True when opacity has reached 0

  PlayButton(float x, float y, float d) {        // Constructor
    this.x = x;                                  // Store x
    this.y = y;                                  // Store y
    this.d = d;                                  // Store diameter
  }

  void setPosition(float x, float y) {           // Lets main sketch move/recenter the button
    this.x = x;                                  // Update x
    this.y = y;                                  // Update y
  }

  void update() {                                // Updates the fade animation
    if (!fading || fadedOut) return;             // Only fade if fading is active and not already done

    opacity -= 7;                                // Reduce opacity a bit each frame
    if (opacity <= 0) {                          // If we've faded past 0
      opacity = 0;                               // Clamp to 0
      fadedOut = true;                           // Mark as fully gone
    }
  }

  void display() {                               // Draws the button
    if (fadedOut) return;                        // If fully gone, draw nothing

    noStroke();                                  // No outline for shapes

    fill(255, opacity);                          // White circle with current opacity
    ellipse(x, y, d, d);                         // Draw the circular button

    fill(0, opacity);                            // Black triangle with same opacity
    float w = d * 0.30;                          // Triangle width based on button size
    float h = d * 0.55;                          // Triangle height based on button size

    triangle(                                    // Draw the "play" triangle
      x - w/2, y - h/2,                          // Left top point
      x - w/2, y + h/2,                          // Left bottom point
      x + w, y                                   // Right middle point
    );
  }

  boolean handleClick(float mx, float my) {      // Checks if mouse click is inside the button
    if (dist(mx, my, x, y) < d/2) {              // If distance from click to center is inside radius
      fading = true;                             // Start fading out
      return true;                               // Tell main sketch click was successful
    }
    return false;                                // Click was outside, do nothing
  }
}
