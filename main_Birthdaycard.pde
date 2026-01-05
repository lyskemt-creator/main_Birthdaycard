// Circus Bithday Card
// Lyske Tromp (3537048)
// Date: 27 Nov 2025

// Click the play button to start the animation and music.

// Required files (in /data folder):
// circustent.jpg, clown1.png, clown2.png, ticket.png, song.mp3, greeting.txt, Jokerman-Regular-48.vlw

// Library:
// processing.sound.*

import processing.sound.*;                      // Import Sound library so we can play audio

final int CANVAS_SIZE = 800;                    // Width and height of the sketch window (square)
final int TICKET_DELAY = 3000;                  // Delay (ms) before the ticket starts moving after clicking play

final float DANCE_SCALE = 0.25;                 // Scale factor for the dancing clown image
final float DANCE_AMP = 18;                     // Up/down movement amplitude for dancing clown
final float DANCE_ROTAMP = 0.20;                // Rotation amplitude for dancing clown

final float UNI_SCALE = 0.5;                    // Scale factor for the unicycle clown image
final float UNI_SPEED = 2.5;                    // Horizontal speed for the unicycle clown

final int CONFETTI_COUNT = 200;                 // Number of confetti particles on screen

final float TICKET_TARGET_X = 0.5;              // Ticket X position as fraction of width
final float TICKET_TARGET_Y = 0.25;             // Ticket target Y position as fraction of height
final float TICKET_SPEED = 8;                   // Speed at which ticket moves upward

final float TEXT_OFFSET_X = -75;                // Text offset relative to the ticket (X)
final float TEXT_OFFSET_Y = -65;                // Text offset relative to the ticket (Y)

PImage bgImg, clownDancingImg, clownUnicycleImg, ticketImg; // Variables to store loaded images
PFont font;                                     // Variable to store loaded font
SoundFile music;                                // Variable to store loaded music file

Background bg;                                  // Background object (draws the circus tent image)
PlayButton playButton;                          // Play button object (clickable + fades out)
DancingClown dancingClown;                      // Dancing clown object (bounces + rotates + flips)
UnicycleClown unicycleClown;                    // Unicycle clown object (moves left/right + flips)
Ticket ticket;                                  // Ticket object (slides up after delay)
Text greetingText;                              // Text object (loads greeting.txt and animates letters)
Confetti[] confetti;                            // Array holding many confetti objects

boolean playing = false;                        // State: false = waiting for click, true = animation running

void settings() {                               // settings() runs before setup(), used to configure the window
  size(CANVAS_SIZE, CANVAS_SIZE, P2D);          // Create the sketch window with a fixed size and the P2D renderer
  smooth(4);                                    // Enable anti-aliasing to make shapes and edges smoother
  pixelDensity(displayDensity());               // Match the sketch resolution to the screen's pixel density
}                                               // End of settings()

void setup() {                                  // setup() runs once after the window has been created
  loadAssets();                                 // Load images, fonts, and sound files from the data folder
  createObjects();                              // Create all objects (clowns, button, ticket, text, etc.)
}                                               // End of setup()

void draw() {                                   // Runs every frame (loop)
  background(0);                                // Clear screen with black

  bg.display();                                  // Draw the background image scaled to fit
  drawConfetti();                                // Update + draw all confetti particles
  drawPlayButton();                              // Update + draw the play button (if not faded out)

  if (!playing) return;                          // If not started yet, stop here (nothing else animates)

  dancingClown.update();                         // Update dancing clown internal time/animation state
  dancingClown.display();                        // Draw the dancing clown to the screen

  ticket.update();                               // Update ticket (wait delay, then move up)
  ticket.display();                              // Draw ticket (only after it becomes active)

  greetingText.display();                        // Draw animated greeting text (moves with ticket)

  unicycleClown.update();                        // Update unicycle clown position and bouncing off edges
  unicycleClown.display();                       // Draw the unicycle clown
}

void mousePressed() {                            // Runs once when mouse is pressed
  if (playing) return;                           // If already playing, ignore further clicks

  if (playButton.handleClick(mouseX, mouseY)) {  // If click was inside the play button
    playing = true;                              // Switch state so animations start
    ticket.startAfterDelay(TICKET_DELAY);        // Start ticket after a fixed delay
    music.play();                                // Start playing the background music
  }
}

void loadAssets() {                              // Loads all files from the /data folder
  music = new SoundFile(this, "song.mp3");       // Load MP3 sound file
  bgImg = loadImage("circustent.jpg");           // Load background image
  clownDancingImg = loadImage("clown1.png");     // Load dancing clown image
  clownUnicycleImg = loadImage("clown2.png");    // Load unicycle clown image
  ticketImg = loadImage("ticket.png");           // Load ticket image
  font = loadFont("Jokerman-Regular-48.vlw");    // Load font (must be in .vlw format)
}

void createObjects() {                           // Creates all objects after assets are loaded
  bg = new Background(bgImg);                    // Create background object with its image

  playButton = new PlayButton(width/2, height/2, 80); // Create play button in center with diameter 80

  dancingClown = new DancingClown(               // Create dancing clown object
    width/2, // X position: center
    height * 0.6, // Y position: slightly lower than center
    clownDancingImg, // Image to draw
    DANCE_SCALE, // Scale factor
    DANCE_AMP, // Vertical bounce amplitude
    DANCE_ROTAMP                                 // Rotation amplitude
    );

  unicycleClown = new UnicycleClown(             // Create unicycle clown object
    width * 0.25, // Start at left-ish side
    height * 0.78, // Start near bottom
    clownUnicycleImg, // Image to draw
    UNI_SCALE, // Scale factor
    UNI_SPEED                                    // Horizontal speed
    );

  confetti = new Confetti[CONFETTI_COUNT];       // Allocate the array for confetti objects
  for (int i = 0; i < confetti.length; i++) {    // Loop through every confetti slot
    confetti[i] = new Confetti();                // Create a new confetti particle
  }

  ticket = new Ticket(                           // Create the ticket object
    ticketImg, // Ticket image
    width * TICKET_TARGET_X, // X position where ticket should appear
    height * TICKET_TARGET_Y, // Target Y position where ticket should stop
    TICKET_SPEED                                 // Upward speed
    );

  greetingText = new Text(                       // Create the animated text object
    "greeting.txt", // Text file to load (one line per array entry)
    ticket, // Ticket reference so text can follow the ticket
    TEXT_OFFSET_X, // Text offset X relative to ticket
    TEXT_OFFSET_Y, // Text offset Y relative to ticket
    font                                         // Font to use for drawing text
    );
}

void drawConfetti() {                            // Helper: update + draw all confetti
  for (int i = 0; i < confetti.length; i++) {    // Loop through all particles
    confetti[i].update();                        // Move the particle
    confetti[i].display();                       // Draw the particle
  }
}

void drawPlayButton() {                          // Helper: update + draw play button
  if (playButton.fadedOut) return;               // If fully faded, do nothing

  playButton.setPosition(width/2, height/2);     // Keep the button centered (useful if window size changes)
  playButton.update();                           // Update fade animation
  playButton.display();                          // Draw the button
}
