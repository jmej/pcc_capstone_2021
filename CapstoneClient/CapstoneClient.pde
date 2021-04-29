import processing.video.*;
import processing.sound.*;
import codeanticode.syphon.*;
import com.hamoid.*;
import oscP5.*;
import netP5.*;
import java.io.InputStreamReader;
import java.io.FilenameFilter;
import java.util.*;
import java.util.Arrays;

VideoExport videoExport;
SyphonClient client;
ModNode[] mods = new ModNode[3];
OscP5 oscP5;
NetAddress myRemoteLocation;
Movie movie;
Settings settings;
OscReceiver osc = new OscReceiver();
SoundFile testaudio;
FFT fft;
Amplitude rms;

int curMod = 0;
int curFrame = 0;
PGraphics canvas;
boolean saved = false;
String path = "";
String audioFilePath = "";
String audioOut = "";
String settingsPath;

boolean LOOP;
boolean EXTRACT_AUDIO;
boolean AUDIODONE = false;
int PIX_DIM; 
int REMOTE_PORT;
int INCOMING_PORT;
String videoFilePath;

void setup() {
  rectMode(CENTER);
  size(1280, 720, P2D);
  colorMode(RGB, 255);
  
  settings = new Settings(this);
  
  LOOP = (boolean)settings.get("videoLoop");
  EXTRACT_AUDIO = (boolean)settings.get("extractAudio");
  PIX_DIM = (int)settings.get("defaultDim"); 
  REMOTE_PORT = (int)settings.get("remoteOSCPort");
  INCOMING_PORT = (int)settings.get("incomingOSCPort");
  videoFilePath = (String)settings.get("pathToVid");
  
  oscP5 = new OscP5(this,INCOMING_PORT);
  myRemoteLocation = new NetAddress("127.0.0.1",REMOTE_PORT);
  
  canvas = createGraphics(1920, 1080, P2D);
    
  mods[0] = new BlendNode();
  mods[1] = new HueNode();
  //mods[2] = new GrowPixNode(); 
  mods[2] = new AtoVNode();
  
  
  movie = new Movie(this, videoFilePath);
  //movie.loop();
  movie.play();
  movie.jump(curFrame);
  movie.pause();
    
  boolean asked = false;
  while (!AUDIODONE) {
    if (!asked) {
      println("also here");
      selectInput("select movie to extract audio from: (the video in the data/ folder)", "fileSelected");
      asked = true;
    }
    
    if (millis() %100 == 0) {    
     // println("HERE"); 
    }
  }

  println("PATH: "  + audioFilePath);
    
  while (audioFilePath == "") {
    println("WAITING");
  }
     
  audioOut = saveAudio(audioFilePath);
  videoExport = new VideoExport(this);
  videoExport.setFrameRate(movie.frameRate);
  videoExport.setAudioFileName(audioOut);
      
  testaudio = new SoundFile(this, audioOut);

  fft = new FFT(this, 256);
  rms = new Amplitude(this);
  // For nodes that have a specfic color to track...
  color trackColor = color(random(100), random(100), random(100));
  
  // Loop through the nodes and init, set default vars
  for (int i = 0; i < mods.length; i++) {
    mods[i].init();
    mods[i].setColor(trackColor);
    mods[i].setDim(PIX_DIM);
  }
}

void draw() {   //<>//
  canvas.beginDraw();
  canvas.image(movie, 0, 0);
  canvas.endDraw();

  PImage f = createImage(width, height, ALPHA);
   
  // Resize the image to our dims
  f.copy(canvas, 0, 0, canvas.width, canvas.height, 0, 0, f.width, f.height);
 
  // Continually pass the modded version to each Node
  for (int i = 0; i < mods.length; i++) {
    if (mods[i].active()) {
      f = mods[i].mod(f);
    }
  }
  
  if (curFrame == 0) { 
    videoExport.startMovie();
    println("STARTED!");
  } 
     
  image(f, 0, 0, f.width, f.height);
  videoExport.saveFrame();
  curFrame++;
  setFrame(curFrame); //<>//
}

void oscEvent(OscMessage m) {
  PImage frame = osc.event(m);
  
  if (frame != null) {
    println("GOT A FRAME!");
  }
}

void keyPressed() {
  if (key == 'q') {
    //println("TOTAL CLIENT FRAMES);
    videoExport.endMovie();
  
    exit();
  }
}

/***
The following function is adapted from 
Libraries->Video->Movie->Frames
***/
void setFrame(int n) {
  // The duration of a single frame:
  float frameDuration = 1.0 / movie.frameRate;
  int len = getLength();
    
  // We move to the middle of the frame by adding 0.5:
  float where = (n + 0.5) * frameDuration; 
    
  // Taking into account border effects:
  float diff = movie.duration() - where;
  if (diff < 0) {
    where += diff - 0.25 * frameDuration;
  }
  
  movie.play();
  println("We are " + where*movie.frameRate+ " out of " + len + " with a framerate of " + frameRate);
  
  if (where*movie.frameRate >= len) {
    if (LOOP) {
      where = 0;
    } else {
      println("TOTAL FRAMES: " + curFrame);
      videoExport.endMovie();
      exit();
    }
  }
  
  movie.jump(where);
  movie.pause();  
}  

int getLength() {
  return int(movie.duration() * movie.frameRate);
}

void movieEvent(Movie m) {
  m.read();
}


/***
The following three functions were adapted from
https://discourse.processing.org/t/monitoring-process-of-ffmpeg-in-processing/17950/6
***/
String saveAudio(String fileName) {
  saved = true;
  String ffmpegPath = "/usr/local/bin/ffmpeg";
  String audioOut = dataPath(fileName + "_audio.mp3");
  String[] commands = {
    ffmpegPath,
    "-i", 
    path,
    audioOut
  };

  ProcessBuilder processBuilder = new ProcessBuilder(commands);
  Process process;
  File ffmpegOutputLog;
  processBuilder.redirectErrorStream(true);
  ffmpegOutputLog = new File(dataPath(fileName+"_ffmpegLog.txt"));
  processBuilder.redirectOutput(ffmpegOutputLog);
  processBuilder.redirectInput(ProcessBuilder.Redirect.PIPE);
  try {
    process = processBuilder.start();
  } 
  catch (Exception e) {
    e.printStackTrace();
    println(ffmpegOutputLog);
  }
  
  return audioOut;
}

void fileSelected(File selection) { 
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    path = selection.getAbsolutePath();
    println(path);
    audioFilePath = path;
    audioFilePath = cleanFileName(audioFilePath);
    AUDIODONE = true;
  }
}

String cleanFileName(String unclean) { 
  //https://forum.processing.org/two/discussion/16801/is-there-a-way-to-check-what-system-a-processing-sketch-is-running-on
  String[] list;
  char delim = '\\';
  list = split(unclean, delim);
  int arrayPos = list.length-1;
  return list[arrayPos];
}
