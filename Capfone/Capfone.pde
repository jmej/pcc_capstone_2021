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
SoundFile soundSource;
FFT fft;
Amplitude rms;

// Internal classes
Pix2JSON p2j;         // Calculates pixel data to be fed to a markov chain
FrameData frameData;  // Generates json file for max nodes
Settings settings;    // Contains global settings from data/settings.json
OscClient oscCli;     // General purpose OSC stuff
ModNode[] mods;       // All of our processing nodes for this run
  
int curFrame = 0;
int lastMovieUpdate = 0;
PGraphics canvas;
PImage infoFrame = null;
boolean saved = false;
String path = "";
String audioFilePath = "";
String audioOut = "";
String settingsPath;

// Settings from settings.json and related
boolean LOOP;
boolean EXTRACT_AUDIO;
boolean AUDIODONE = false;
boolean MARKOV_GEN;
int PIX_DIM; 
int START_FRAME;
String VIDEO_IN_PATH;
int FRAME_MOD_COUNT;
float RMS_SCALED;
float[] fftData;


void setup() {
  size(1280, 720, P2D); // 1024, 576,
  noStroke();
  rectMode(CENTER);
  colorMode(RGB, 255);
  
  settings = new Settings(this);    
  LOOP = (boolean)settings.get("videoLoop");
  EXTRACT_AUDIO = (boolean)settings.get("extractAudio");
  PIX_DIM = (int)settings.get("defaultDim"); 
  VIDEO_IN_PATH = (String)settings.get("videoInputPath");
  START_FRAME = (int)settings.get("startFrame");
  FRAME_MOD_COUNT = (int)settings.get("frameModCount");
  MARKOV_GEN = (boolean)settings.get("markovGen");
  int fftBands = (int)settings.get("fftBands");
  String classNames = (String)settings.get("nodeNames");
  String[] classList = classNames.split(",");
  curFrame = START_FRAME;
  fftData = new float[fftBands];
  path = sketchPath("data/" + VIDEO_IN_PATH);

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
        mods[i] = new AtoVNode(fftBands);
        break;
      case "FlipBlendNode":
        mods[i] = new FlipBlendNode();
        break;
      case "HarmDistNode":
        mods[i] = new HarmDistNode();
        break;   
      case "ReadMarkovNode":
        mods[i] = new ReadMarkovNode();
        break;    
      case "CircleizeNode":
        mods[i] = new CircleizeNode();
        break;  
      case "PixSizeNode": 
        mods[i] = new PixSizeNode();
        break;
      case "ExplodeColorNode":
        mods[i] = new ExplodeColorNode();
        break;
      case "ConvolverNode":
        mods[i] = new ConvolverNode();
        break;
        
    }
  }
  
  p2j = new Pix2JSON();
  p2j.init(settings);
  oscCli = new OscClient();
  frameData = new FrameData();
  frameData.init(settings);
  
  oscP5 = new OscP5(this, (int)settings.get("incomingOSCPort"));
  myRemoteLocation = new NetAddress("127.0.0.1",(int)settings.get("remoteOSCPort"));
  
  canvas = createGraphics(1920, 1080, P2D); 
  movie = new Movie(this, VIDEO_IN_PATH);
  movie.play();
  movie.volume(0);
  movie.jump(curFrame);
  movie.pause();
  
  if ((boolean)settings.get("promptVideoPath")) {
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
    audioFilePath = VIDEO_IN_PATH;
  }
  
  audioOut = saveAudio(audioFilePath);
  println("AUDIO SEPARATED FROM VIDEO" + audioOut);
  
  // Video export settings
  videoExport = new VideoExport(this);
  videoExport.setFrameRate(movie.frameRate);
  videoExport.setLoadPixels(false);
  videoExport.setQuality((int)settings.get("videoQuality"), (int)settings.get("audioQuality"));
  videoExport.setDebugging((boolean)settings.get("videoExportDebug"));
  
  // For nodes that have a specfic color to track...
  color TRACK_COLOR = color(random(100), random(100), random(100));
   
  try {
    // Loop through the nodes and init, set default vars
    for (int i = 0; i < mods.length; i++) {
      mods[i].init(settings);
      mods[i].setDim(PIX_DIM);
      mods[i].setColor(TRACK_COLOR);
    }
  } catch (NullPointerException e) { //<>// //<>//
    println("Node init error. Check node names in settings.json: " + e.getMessage());
  }
  
  // Sound / fft stuff
  soundSource = new SoundFile(this, audioOut);
  fft = new FFT(this, fftBands);
  rms = new Amplitude(this);
  fft.input(soundSource);
  rms.input(soundSource);
}

void draw() {  //<>//
  canvas.beginDraw();
  canvas.image(movie, 0, 0);
  canvas.endDraw();

  PImage f = createImage(width, height, ALPHA);
   
  // Resize the image to our dims
  f.copy(canvas, 0, 0, canvas.width, canvas.height, 0, 0, f.width, f.height);
  
  // Calculate fft, amplitude stuff for this frame
  soundSource.play(1, 0.0, 1.0, 0, movie.time());
  soundSource.amp(1);
  fft.analyze();
  arrayCopy(fft.spectrum, fftData);
  
  RMS_SCALED = rms.analyze() * 13;
 
  // Continually pass the modded version to each Node
  for (int i = 0; i < mods.length; i++) {
    if (mods[i].active()) {
      f = mods[i].mod(f);
    }
  }
  soundSource.pause();

  if (curFrame == START_FRAME) { 
    videoExport.startMovie();
    println("VIDEO EXPORT STARTED!");
  } 
   
  image(f, 0, 0, f.width, f.height);
  loadPixels();
  
  // Report data every second
  if (curFrame != START_FRAME) {
    int curMovieTime = (int)movie.time();
    if (curMovieTime > lastMovieUpdate) { 
      thread("getFrameInfo");
      lastMovieUpdate = curMovieTime;
      println("Movie frame data updated: " + lastMovieUpdate);
    }
    
    if (p2j.active()) {
      thread("pix2JsonAnalyze");
    }
  }
  
  videoExport.saveFrame();
  curFrame++;
  setFrame(curFrame);
}

/* Thread functions */

void pix2JsonAnalyze() {
  p2j.analyze();
}

void getFrameInfo() {
  frameData.analyze();
}

/* END Thread Functions */

void oscEvent(OscMessage m) {
  PImage frame = oscCli.event(m);
}

void keyPressed() {
  if (key == 'q') {
    endMovie();
  }
}

void mouseClicked() {
  for (int i = 0; i < mods.length; i++) {
    mods[i].clicked();
  }
}

// Called after all frames are processed
void endMovie() {
  String infoPath = frameData.writeToJson();
  oscCli.sendJsonPath(infoPath);
  delay(100);
  oscCli.sendAudioPath(audioOut);

  p2j.sendEndMsg();
 
  println(curFrame + " frames processed, movie length: " + movie.time() + " seconds");
  
  String finalAudio = "";
  while(finalAudio.equals("")) {
    finalAudio = oscCli.getFinalAudio();
    delay(1000);
    println("no audio...delaying 1s");
  }
  
  videoExport.setAudioFileName(finalAudio);   
  videoExport.endMovie();
  
  exit();
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
      endMovie();
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
  
  delay(1000);
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
