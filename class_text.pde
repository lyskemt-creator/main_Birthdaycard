class Text {                                              // Animated text that follows the ticket and animates per letter
  String[] lines;                                         // Lines loaded from the text file
  Ticket ticket;                                          // Reference to ticket (for position and active state)
  float offsetX, offsetY;                                 // Offsets so text sits nicely on the ticket
  PFont font;                                             // Font to draw with

  PImage bgImg;                                           // Background image used for pixel sampling

  float waveHeight = 5;                                   // How far wave letters move up/down

  float fontSize = 22;                                    // Font size for greeting text
  float lineSpacing = 40;                                 // Space between lines

  ArrayList<Letter> letters;                              // All letters as objects (inheritance!)

  Text(String filename, Ticket ticket, float offsetX, float offsetY, PFont font, PImage bgImg) { // Constructor
    lines = loadStrings(filename);                        // Load all lines from file into array
    this.ticket = ticket;                                 // Store ticket reference
    this.offsetX = offsetX;                               // Store x offset
    this.offsetY = offsetY;                               // Store y offset
    this.font = font;                                     // Store font reference
    this.bgImg = bgImg;                                   // Store background image reference

    buildLetters();                                       // Turn the text into Letter objects (once)
  }

  void buildLetters() {                                   // Build all Letter objects from the loaded lines
    letters = new ArrayList<Letter>();                    // Create the list

    if (lines == null) return;                            // Safety: no file loaded = nothing to build

    textFont(font);                                       // Needed so textWidth() is correct
    textSize(fontSize);                                   // Needed so textWidth() is correct
    textAlign(CENTER, CENTER);                            // Match drawing alignment

    for (int lineIndex = 0; lineIndex < lines.length; lineIndex++) { // Loop through each line
      String line = lines[lineIndex];                     // Current line
      float totalWidth = textWidth(line);                 // Total line width in pixels
      float cursorX = -totalWidth / 2;                    // Start at left edge so line is centered

      for (int i = 0; i < line.length(); i++) {           // Loop through each character
        char ch = line.charAt(i);                         // Get the character
        float charWidth = textWidth(str(ch));             // Measure character width

        float relX = cursorX + charWidth / 2;             // Center the character in its slot
        float relY = lineIndex * lineSpacing;             // Y offset per line

        // Alternate subclasses so you clearly have at least two types
        if (i % 2 == 0) {
          letters.add(new WaveLetter(ch, relX, relY, font, fontSize, bgImg, waveHeight));
        } else {
          letters.add(new BounceLetter(ch, relX, relY, font, fontSize, bgImg, 3));
        }

        cursorX += charWidth;                             // Move cursor for next character
      }
    }
  }

  void display() {                                        // Draw the text each frame
    if (!ticket.active || lines == null) return;          // Only draw if ticket is active and lines were loaded

    float baseX = ticket.x + offsetX;                     // Compute text base X relative to ticket
    float baseY = ticket.y + offsetY;                     // Compute text base Y relative to ticket

    for (int i = 0; i < letters.size(); i++) {            // Loop through all letter objects
      Letter l = letters.get(i);                          // Get the current letter
      l.setAnchor(baseX, baseY);                          // Make letters follow the ticket
      l.update();                                         // Run the subclass animation
      l.display();                                        // Draw the letter
    }
  }
}
