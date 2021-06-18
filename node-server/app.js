var express = require('express');
var app = express();
var path = require('path');
var formidable = require('formidable');
var fs = require('fs');

app.set('view engine', 'pug');
app.set('views', './views');
app.use(express.static(path.join(__dirname, 'public')));

app.get('/', function(req, res){
  //var options = url.parse(req.url, true);
  //var mime = Helper.getMime(options);
  //serveFile(res, options.pathname, mime);
  res.sendFile(path.join(__dirname, 'index.html'));
});

app.get('/gallery', (req, res) => {
    let images = getImagesFromDir(path.join(__dirname, 'public/finished'));
     res.render('gallery', { title: 'spores', images: images })
});

// dirPath: target image directory
function getImagesFromDir(dirPath) {
 
    // All iamges holder, defalut value is empty
    let allImages = [];
 
    // Iterator over the directory
    let files = fs.readdirSync(dirPath);
 
    // Iterator over the files and push jpg and png images to allImages array.
    for (file of files) {
        let fileLocation = path.join(dirPath, file);
        var stat = fs.statSync(fileLocation);
        if (stat && stat.isDirectory()) {
            getImagesFromDir(fileLocation); // process sub directories
        } else if (stat && stat.isFile() && ['.jpg'].indexOf(path.extname(fileLocation)) != -1) {
            let videoLink = file.slice(0, file.length-4)+".mp4";
            allImages.push({video: 'finished/'+videoLink, location: 'finished/'+file}); // push all .jpf and .png files to all images 
            console.log(videoLink);
        }
    }
 
    // return all images in array formate
    return allImages;
}

app.post('/upload', function(req, res){
  // create an incoming form object
  var form = new formidable.IncomingForm();
  // specify that we want to allow the user to upload multiple files in a single request
  form.multiples = true;
  // store all uploads in the /uploads directory
  form.uploadDir = path.join(__dirname, '/uploads');
  // every time a file has been uploaded successfully,
  // rename it to it's orignal name
  form.on('file', function(field, file) {
    fs.rename(file.path, path.join(form.uploadDir, file.name), () => {
      console.log("\nFile Renamed!\n");
    });
  });
  // log any errors that occur
  form.on('error', function(err) {
    console.log('An error has occured: \n' + err);
  });
  // once all the files have been uploaded, send a response to the client
  form.on('end', function() {
    res.end('success');
  });
  // parse the incoming request containing the form data
  form.parse(req);
});

var server = app.listen(80, function(){
  console.log('Server listening on port 80');
});