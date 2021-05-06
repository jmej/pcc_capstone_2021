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
OscClient oscCli = new OscClient();
SoundFile testaudio;
FrameData frameData;
FFT fft;
Amplitude rms;
ModNode[] mods;

int curFrame = 0;
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
int PIX_DIM; 
String VIDEO_IN_PATH;


void setup() {
  size(1280, 720, P2D);
  noStroke();
  rectMode(CENTER);
  colorMode(RGB, 255);
  
  settings = new Settings(this);    
  LOOP = (boolean)settings.get("videoLoop");
  EXTRACT_AUDIO = (boolean)settings.get("extractAudio");
  PIX_DIM = (int)settings.get("defaultDim"); 
  VIDEO_IN_PATH = (String)settings.get("videoInputPath");  
  int fftBands = (int)settings.get("fftBands");
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
        mods[i] = new AtoVNode(fftBands);
        break;
      case "FlipBlendNode":
        mods[i] = new FlipBlendNode();
        break;   
    }
  }
  
  frameData = new FrameData(PIX_DIM);
  oscP5 = new OscP5(this, (int)settings.get("incomingOSCPort"));
  myRemoteLocation = new NetAddress("127.0.0.1",(int)settings.get("remoteOSCPort"));
  
  canvas = createGraphics(1920, 1080, P2D); 
  movie = new Movie(this, VIDEO_IN_PATH);
  movie.play();
  movie.jump(curFrame);
  movie.pause();
  println("FRAME RATE " + movie.frameRate);
  
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
  videoExport = new VideoExport(this);
  videoExport.setFrameRate(movie.frameRate);
  videoExport.setLoadPixels(false);
  videoExport.setQuality((int)settings.get("videoQuality"), (int)settings.get("audioQuality"));
  videoExport.setDebugging((boolean)settings.get("videoExportDebug"));
  //videoExport.setAudioFileName(audioOut);     // Moved to movieEnd()
  
  testaudio = new SoundFile(this, audioOut);
  fft = new FFT(this, fftBands);
  rms = new Amplitude(this);
  
  // For nodes that have a specfic color to track...
  color TRACK_COLOR = color(random(100), random(100), random(100));
  
  try {
    // Loop through the nodes and init, set default vars
    for (int i = 0; i < mods.length; i++) {
      mods[i].init(settings);
      mods[i].setColor(TRACK_COLOR);
      mods[i].setDim(PIX_DIM);
    }
  } catch (NullPointerException e) {
    println("Node init error. Check node names in settings.json: " + e.getMessage());
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
  updatePixels();
  loadPixels();
  thread("getFrameInfo");
  
  videoExport.saveFrame();
  curFrame++;
  setFrame(curFrame);
}

void getFrameInfo() {
    frameData.analyze();
}

void oscEvent(OscMessage m) {
  PImage frame = oscCli.event(m);
  
  if (frame != null) {
    println("GOT A FRAME!");
  }
}

void keyPressed() {
  if (key == 'q') {
    endMovie();
  }
}

// Called after all frames are processed
void endMovie() {
  videoExport.setAudioFileName(audioOut);   
  videoExport.endMovie();
  FrameInfo fi  = frameData.data.get(10);
  String infoPath = frameData.writeToJson();
  oscCli.sendJsonPath(infoPath);
  
  println("frame data: " + fi.hue + ", " + fi.saturation + ", " + fi.brightness);
  println(curFrame + " frames processed, movie length: " + movie.time() + " seconds");
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
