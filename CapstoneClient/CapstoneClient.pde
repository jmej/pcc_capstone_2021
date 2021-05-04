import processing.video.*;
import processing.sound.*;
import com.hamoid.*;
import oscP5.*;
import netP5.*;
import java.io.InputStreamReader;
import java.io.FilenameFilter;
import java.util.*;
import java.util.Arrays;

VideoExport videoExport;
OscP5 oscP5;
NetAddress myRemoteLocation;
Movie movie;
Settings settings;
OscReceiver osc = new OscReceiver();
SoundFile testaudio;
FFT fft;
Amplitude rms;
ModNode[] mods;

int curFrame = 0;
PGraphics canvas;
boolean saved = false;
String path = "";
String audioFilePath = "";
String audioOut = "";
String settingsPath;

// Settings from settings.json and related
boolean LOOP;
boolean EXTRACT_AUDIO;
boolean AUDIODONE = false;
boolean PROMPT_AUDIO;
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
  PROMPT_AUDIO = (boolean)settings.get("promptAudio");
  videoFilePath = (String)settings.get("pathToVid");
  String classNames = (String)settings.get("nodeNames");
  String[] classList = classNames.split(",");
  
  if (classList.length == 0) {
    println("No nodes loaded. Check settings.json");
    return;
  }
  
  mods = new ModNode[classList.length];

  // Choose the nodes you want to load by changing setting.json
  for (int i = 0; i < classList.length; i++) {
    switch(classList[i]) {
      case "BlendNode":
        mods[i] = new BlendNode();
        break;
      case "HueNode":
        mods[i] = new HueNode();
        break;
      case "GrowPixNode" : 
        mods[i] = new GrowPixNode();
        break;
      case "AtoVNode":
        mods[i] = new AtoVNode();
        break;
      case "FlipBlendNode":
        mods[i] = new FlipBlendNode();
        break;   
    }
  }
  
  oscP5 = new OscP5(this,INCOMING_PORT);
  myRemoteLocation = new NetAddress("127.0.0.1",REMOTE_PORT);
  
  canvas = createGraphics(1920, 1080, P2D); 
  movie = new Movie(this, videoFilePath);
  movie.play();
  movie.jump(curFrame);
  movie.pause();
  
  if (PROMPT_AUDIO) {
    boolean asked = false;
    
    while (!AUDIODONE) {
      if (!asked) {
        selectInput("select movie to extract audio from: (the video in the data/ folder)", "fileSelected");
        asked = true;
      }
    }
      
    while (audioFilePath == "") {
      println("WAITING");
    } 
  } else {
    audioFilePath = videoFilePath;
  }
  
  audioOut = saveAudio(audioFilePath);
  println("AUDIO OUT" + audioOut);
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
    mods[i].init(settings);
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
    println("VIDEO EXPORT STARTED!");
  } 
     
  image(f, 0, 0, f.width, f.height);
  videoExport.saveFrame();
  curFrame++;
  setFrame(curFrame);
}

void oscEvent(OscMessage m) {
  PImage frame = osc.event(m);
  
  if (frame != null) {
    println("GOT A FRAME!");
  }
}

void keyPressed() {
  if (key == 'q') {
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
