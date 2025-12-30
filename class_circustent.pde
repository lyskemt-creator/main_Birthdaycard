class Background {                                  // Background image that scales to fit without stretching
  PImage img;                                       // Image to draw

  Background(PImage img) {                          // Constructor
    this.img = img;                                 // Store image reference
  }

  void display() {                                  // Draw background each frame
    if (img == null) return;                        // Safety check

    float imgRatio = (float) img.width / img.height; // Aspect ratio of image
    float canvasRatio = (float) width / height;      // Aspect ratio of canvas

    float w, h;                                     // Final draw width and height

    if (canvasRatio > imgRatio) {                   // If canvas is relatively wider than image
      h = height;                                   // Match height
      w = h * imgRatio;                             // Compute width to keep aspect ratio
    } else {                                        // If canvas is relatively taller than image
      w = width;                                    // Match width
      h = w / imgRatio;                             // Compute height to keep aspect ratio
    }

    imageMode(CORNER);                              // Draw using top-left corner as reference
    image(img, (width - w) / 2, (height - h) / 2, w, h); // Center the image and draw scaled
  }
}
