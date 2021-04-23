import processing.video.*;
import codeanticode.syphon.*;
import com.hamoid.*;
import oscP5.*;
import netP5.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.spi.*;
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
ArrayList<PImage> frames;
ArrayList<PImage> drawFrames;
int curMod = 0;
int curFrame = 0;
PGraphics canvas;
boolean saved = false;
String path = "";
String audioFilePath = "";
String settingsPath;

boolean LOOP;
boolean EXTRACT_AUDIO;
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
 
  frames = new ArrayList<PImage>();
  drawFrames = new ArrayList<PImage>();

  canvas = createGraphics(1920, 1080, P2D);
    
  mods[0] = new BlendNode();
  mods[1] = new HueNode();
  mods[2] = new GrowPixNode(); 
  //mods[3] = new CircleizeNode();
  
  // For nodes that have a specfic color to track...
  color trackColor = color(random(100), random(100), random(100));
  
  // Loop through the nodes and init, set default vars
  for (int i = 0; i < mods.length; i++) {
    mods[i].init();
    mods[i].setColor(trackColor);
    mods[i].setDim(PIX_DIM);
  }

  movie = new Movie(this, videoFilePath);
  //movie.loop();
  movie.play();
  movie.jump(curFrame);
  movie.pause();
  
  videoExport = new VideoExport(this);
  videoExport.setFrameRate(movie.frameRate);
  
  if (EXTRACT_AUDIO) {
    selectInput("select movie to extract audio from: (the video in the data/ folder)", "fileSelected");
  }
}

void draw() {
  if (EXTRACT_AUDIO) {
    if (audioFilePath != "" && !saved) {
      saveAudio(audioFilePath);
      videoExport.setAudioFileName(audioFilePath);
    } else if (!saved) return;
  }
  
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


/***
Not used for anything yet
***/
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### SERVER received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());  

  try {
    float floatVal = 0;
    String stringVal = "";
    
    if(theOscMessage.checkAddrPattern("/capstoneCli")!=true) {
      return;
    }
    
    if(theOscMessage.checkTypetag("f")) {
      floatVal = theOscMessage.get(0).floatValue(); 
    }
    
    if(theOscMessage.checkTypetag("s")) {
      stringVal = theOscMessage.get(0).stringValue();
      if (stringVal.equals("track")) {
  
      }
    } 
  } catch (Exception e) {
    println(e.getMessage());
  }
}

void keyPressed() {
  if (key == 'q') {
    client.stop();  
    println("TOTAL CLIENT FRAMES: " + frames.size());
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
void saveAudio(String fileName) {
  saved = true;
  String ffmpegPath = "/usr/local/bin/ffmpeg";
  String[] commands = {
    ffmpegPath,
    "-i", 
    path,
    dataPath(fileName + "_audio.mp3")
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
}

void fileSelected(File selection) { 
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    path = selection.getAbsolutePath();
    println(path);
    audioFilePath = path;
    audioFilePath = cleanFileName(audioFilePath);
    println(audioFilePath);
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
