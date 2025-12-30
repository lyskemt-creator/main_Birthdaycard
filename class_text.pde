class Text {                                              // Animated text that follows the ticket and waves per letter
  String[] lines;                                         // Lines loaded from the text file
  Ticket ticket;                                          // Reference to ticket (for position and active state)
  float offsetX, offsetY;                                 // Offsets so text sits nicely on the ticket
  PFont font;                                             // Font to draw with

  float waveSpeed = 0.003;                                // Controls how fast the wave animation moves
  float waveHeight = 5;                                   // Controls how far letters move up/down

  color outlineColor = #C60808;                           // Outline color (red)
  color fillColor = #FAEC4E;                              // Fill color (yellow)

  Text(String filename, Ticket ticket, float offsetX, float offsetY, PFont font) { // Constructor
    lines = loadStrings(filename);                        // Load all lines from file into array
    this.ticket = ticket;                                 // Store ticket reference
    this.offsetX = offsetX;                               // Store x offset
    this.offsetY = offsetY;                               // Store y offset
    this.font = font;                                     // Store font reference
  }

  void display() {                                        // Draw the text each frame
    if (!ticket.active || lines == null) return;          // Only draw if ticket is active and lines were loaded

    textFont(font);                                       // Set the font used for text()
    textSize(22);                                         // Set font size
    textAlign(CENTER, CENTER);                            // Align text around its center

    float baseX = ticket.x + offsetX;                     // Compute text base X relative to ticket
    float baseY = ticket.y + offsetY;                     // Compute text base Y relative to ticket

    for (int i = 0; i < lines.length; i++) {              // Loop through each line from the file
      drawWaveLine(lines[i], baseX, baseY + i * 40);      // Draw that line, spaced 40px apart
    }
  }

  void drawWaveLine(String line, float centerX, float y) { // Draws a single line letter-by-letter with a wave
    float time = millis() * waveSpeed;                    // Convert current time into a wave phase
    float totalWidth = textWidth(line);                   // Compute total width of the entire string
    float cursorX = centerX - totalWidth / 2;             // Start drawing at the left edge so the line is centered

    for (int i = 0; i < line.length(); i++) {             // Loop through each character in the line
      char ch = line.charAt(i);                           // Get the character at index i
      float charWidth = textWidth(str(ch));               // Measure that character width in current font
      float waveOffset = sin(time + i * 0.4) * waveHeight; // Compute vertical wave offset for this character

      drawOutlinedChar(ch, cursorX + charWidth / 2, y + waveOffset); // Draw character centered in its slot
      cursorX += charWidth;                               // Move cursor to the right for next character
    }
  }

  void drawOutlinedChar(char ch, float x, float y) {      // Draw a character with outline + fill
    fill(outlineColor);                                   // Use outline color
    text(ch, x + 2, y);                                   // Outline right
    text(ch, x - 2, y);                                   // Outline left
    text(ch, x, y + 2);                                   // Outline down
    text(ch, x, y - 2);                                   // Outline up

    fill(fillColor);                                      // Switch to fill color
    text(ch, x, y);                                       // Draw the main character on top
  }
}
