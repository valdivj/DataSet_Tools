//*******************************************************
// Image labelling tool for Detectnet dataset v1.0.0
// Alper ALTINOK, 2017
// ******************************************************
// If you want to label objects with other then "car",
// then simply find "car" word in this code somewhere down below
// and change it to any custom dataset label you want.
// This version of macro is not designed to preserve multiple labels
// like (car, vehicle, pedestrian, etc). Useful only for 
// single label usage.
//*******************************************************


// Action Bar description file :A.L.T
run("Action Bar","/plugins/ActionBar/ALT.txt");
run("Action Bar","/plugins/ActionBar/new_action_bar.ijm");

exit;

<line>
<button> 1 line 1
label=Choose an image file to start/continue labeling
icon=kitti label/image1_1.png
arg=<macro>

macro "open file and roi - C0a0L18f8L818e" {

run("Clear Results");

close("*");
  if (isOpen("ROI Manager")) {
     selectWindow("ROI Manager");
     run("Close");
  }
  


filepath=File.openDialog("CHOOSE THE IMAGE TO EDIT / CREATE LABELS");

open(filepath);

selectWindow(File.name);
getLocationAndSize(x, y, width, height);
setLocation(x+1, y); //makes the invisible sticky action bar, visible..
setLocation(x-1, y); //makes the invisible sticky action bar, visible..

temp = File.nameWithoutExtension;
fn = File.name;
path = File.directory;
roipath = path+temp+".zip";
lineseparator = "\n";
cellseparator = " ";
textPath = path+temp+".txt";
//%%%%%%%%%%%%%%
call("ij.Prefs.set", "my.path", path);
call("ij.Prefs.set", "my.filename", fn);

//myPath = call("ij.Prefs.get", "my.path", filepath);
//print(myPath);
//call("ij.Prefs.set", "my.path", 3);
//%%%%%%%%%%%%%%



 if (File.exists(roipath)) {
	roiManager('open',roipath);
	roiManager("show all with labels");
waitForUser("Formerly recorded labels were loaded from .zip file");
	}
else if (File.exists(textPath)) {
     lines=split(File.openAsString(textPath), lineseparator);
     
header = newArray("label e2 e3 e4 x1 y1 x2 y2 e9 e10 e11 e12 e13 e14 e15");
lines = Array.concat(header,lines);

     // recreates the columns headers

     labels=split(lines[0], cellseparator);
     if (labels[0]==" ")
        k=1; // it is an ImageJ Results table, skip first column
     else
        k=0; // it is not a Results table, load all columns

 //    for (j=k; j<labels.length; j++)
 //       setResult(labels[j],0,0);
j=k;
     // dispatches the data into the new RT
     run("Clear Results");
     for (i=1; i<lines.length; i++) {
        items=split(lines[i], cellseparator);
        for (j=k; j<items.length; j++)
           setResult(labels[j],i-1,items[j]);
     }
     updateResults();
	for (row=0; row<nResults; ++row) { 

		bx1=getResult("x1",row);
		by1=getResult("y1",row);;
		bx2=getResult("x2",row);
		by2=getResult("y2",row);
		width=bx2-bx1;
		height=by2-by1;
		labeltype=getResultString("label",row);
		makeRectangle(bx1,by1,width,height);
		roiManager("Add");
		roiManager("select", row)
		roiManager("rename", labeltype);
}
	roiManager("show all with labels")
   if (isOpen("Results"))
   { 
       selectWindow("Results"); 
       run("Close"); 
   }

   
waitForUser("Formerly recorded labels were loaded from .txt file");  
	roiManager("select", 0);

   }

else {
    waitForUser("No label file (.txt or .zip) was found\nin the directory of current image.\n"+
    "You are starting a new labeling job for this image.");
    roiManager("show all with labels")
    }
    
}


</macro>
<button> 2 line 1
label=Choose folder of current image and save edited labels
icon=kitti label/image2_1.png
arg=<macro>

var u = 0;
 
mainTitle = getTitle();

dir = getDirectory(mainTitle); 

run("Set Measurements...", "bounding display redirect=mainTitle decimal=3");

output = dir;

        for (u=0; u<roiManager("count"); ++u) {

            roiManager("Select", u);
 			roiManager("measure");
    } 

  for (i=0; i<nResults; i++) {
    oldLabel = getResultLabel(i);
    delimiter = indexOf(oldLabel, ":");
    newLabel = substring(oldLabel, delimiter+1);
    setResult("Label", i, newLabel);
  }

		resultsaver();


		
function resultsaver()
{

setBatchMode(true);

if (isOpen("Results")) { 


title1 = "testtable2"; 
title2 = "["+title1+"]"; 
run("New... ", "name="+title2+" type=Table"); 
setBatchMode(true);
selectWindow("Results");
	for (row=0; row<nResults; ++row) { 

	bx1=getResult("BX",row);
	by1=getResult("BY",row);;
	width=getResult("Width",row);
	height=getResult("Height",row);
	labeltype=getResultString("Label",row);
	bx2=bx1+width;
	by2=by1+height;
	print(bx1,by1,bx2,by2);
	print(title2,labeltype+" 0.0 0 0.0 "+bx1+" "+by1+" "+bx2+" "+by2+" 0.0 0.0 0.0 0.0 0.0 0.0 0.0");


	}
	
selectWindow(title1);
newtitle = replace(mainTitle, ".png", ".txt");

//if (isOpen("Results")) { 
saveAs("text", output+File.separator+newtitle);
temp2 = File.nameWithoutExtension;
roiManager("save",dir+temp2+".zip");         
//     }

selectWindow(title1);
selectWindow("testtable2"); 

run("Close");

if (isOpen("Results")) { 
selectWindow("Results"); 
run("Clear Results");
     selectWindow("Results"); 
     run("Close");
     }

          if (isOpen("Log")) { 
         selectWindow("Log"); 
         run("Close"); 
     }
}     
}

</macro>
<button> 3 line 1
label=Save & close all windows
icon=kitti label/image3_1.png
arg=<macro>

var u = 0;



mainTitle = getTitle();

dir = getDirectory(mainTitle); 

run("Set Measurements...", "bounding display redirect=mainTitle decimal=3");

output = dir;

        for (u=0; u<roiManager("count"); ++u) {

            roiManager("Select", u);
 			roiManager("measure");
    } 

  for (i=0; i<nResults; i++) {
    oldLabel = getResultLabel(i);
    delimiter = indexOf(oldLabel, ":");
    newLabel = substring(oldLabel, delimiter+1);
    setResult("Label", i, newLabel);
  }

		resultsaver();


		
function resultsaver()
{
setBatchMode(true);
if (isOpen("Results")) {

title1 = "testtable2"; 
title2 = "["+title1+"]"; 
run("New... ", "name="+title2+" type=Table"); 


selectWindow("Results");
	for (row=0; row<nResults; ++row) { 

	bx1=getResult("BX",row);
	by1=getResult("BY",row);;
	width=getResult("Width",row);
	height=getResult("Height",row);
	labeltype=getResultString("Label",row);
	bx2=bx1+width;
	by2=by1+height;
	print(bx1,by1,bx2,by2);
	print(title2,labeltype+" 0.0 0 0.0 "+bx1+" "+by1+" "+bx2+" "+by2+" 0.0 0.0 0.0 0.0 0.0 0.0 0.0");


	}
	
selectWindow(title1);
newtitle = replace(mainTitle, ".png", ".txt");

saveAs("text", output+File.separator+newtitle);


temp2 = File.nameWithoutExtension;
roiManager("save",dir+temp2+".zip");
}

//run("Close AB", "new action bar");

list = getList("window.titles"); 
     for (i=0; i<list.length; i++){ 
     winame = list[i]; 
     	selectWindow(winame); 
     if (winame!="new action bar"){
     run("Close"); }
	 
     }

}

</macro>

<button> 4 line 1
label=Choose folder of current image and save edited labels
icon=kitti label/image5_1.png
arg=<macro>

var u = 0;
 
mainTitle = getTitle();

dir = getDirectory(mainTitle); 

run("Set Measurements...", "bounding display redirect=mainTitle decimal=3");

output = dir;

        for (u=0; u<roiManager("count"); ++u) {

            roiManager("Select", u);
 			roiManager("measure");
    } 

  for (i=0; i<nResults; i++) {
    oldLabel = getResultLabel(i);
    delimiter = indexOf(oldLabel, ":");
    newLabel = substring(oldLabel, delimiter+1);
    setResult("Label", i, newLabel);
  }

		resultsaver();


		
function resultsaver()
{

setBatchMode(true);

if (isOpen("Results")) {


title1 = "testtable2"; 
title2 = "["+title1+"]"; 
run("New... ", "name="+title2+" type=Table"); 
setBatchMode(true);
selectWindow("Results");
	for (row=0; row<nResults; ++row) { 

	bx1=getResult("BX",row);
	by1=getResult("BY",row);;
	width=getResult("Width",row);
	height=getResult("Height",row);
	labeltype=getResultString("Label",row);
	bx2=bx1+width;
	by2=by1+height;
	print(bx1,by1,bx2,by2);
	print(title2,labeltype+" 0.0 0 0.0 "+bx1+" "+by1+" "+bx2+" "+by2+" 0.0 0.0 0.0 0.0 0.0 0.0 0.0");


	}
	
selectWindow(title1);
newtitle = replace(mainTitle, ".png", ".txt");

//if (isOpen("Results")) { 
saveAs("text", output+File.separator+newtitle);
temp2 = File.nameWithoutExtension;
roiManager("save",dir+temp2+".zip");
save(output+File.separator+mainTitle);
//     }

selectWindow(title1);
selectWindow("testtable2"); 

run("Close");

if (isOpen("Results")) { 
selectWindow("Results"); 
run("Clear Results");
     selectWindow("Results"); 
     run("Close");
     }

          if (isOpen("Log")) { 
         selectWindow("Log"); 
         run("Close"); 
     }
}

}

</macro>

<button> 5 line 1
label=Next image (jpeg or png)
icon=kitti label/image6_1.png
arg=<macro>
  
myPath = call("ij.Prefs.get", "my.path", 0);
myFilename = call("ij.Prefs.get", "my.filename", 1);
//print(myPath);
//print(myFilename);
list = getFileList(myPath);

imglist = newArray();

for (i=0; i<list.length; ++i) {
	if (endsWith(list[i], ".jpg") || endsWith(list[i], ".png")) {
		imglist=Array.concat(imglist,list[i]);
	}
}

orderofFile=indexOfArray(imglist, myFilename);
//Array.print(orderofFile);


//OPENS NEXT FILE\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
run("Clear Results");

close("*");
  if (isOpen("ROI Manager")) {
     selectWindow("ROI Manager");
     run("Close");
  }
  


//filepath=File.openDialog("CHOOSE THE IMAGE TO EDIT / CREATE LABELS");
//open(filepath);

fileorder=orderofFile[0];

if (fileorder<imglist.length-1) {
fileorder = fileorder+1;}
else {orderofFile[0]=0;
fileorder=orderofFile[0];}
myFilename=imglist[fileorder];
open(myPath+File.separator+myFilename);


selectWindow(File.name);
getLocationAndSize(x, y, width, height);
setLocation(x+1, y); //makes the invisible sticky action bar, visible..
setLocation(x-1, y); //makes the invisible sticky action bar, visible..

temp = File.nameWithoutExtension;
fn = File.name;
path = File.directory;
roipath = path+temp+".zip";
lineseparator = "\n";
cellseparator = " ";
textPath = path+temp+".txt";
//%%%%%%%%%%%%%%
call("ij.Prefs.set", "my.path", path);
call("ij.Prefs.set", "my.filename", fn);

//myPath = call("ij.Prefs.get", "my.path", filepath);
//print(myPath);
//call("ij.Prefs.set", "my.path", 3);
//%%%%%%%%%%%%%%



 if (File.exists(roipath)) {
	roiManager('open',roipath);
	roiManager("show all with labels");
waitForUser("Formerly recorded labels were loaded from .zip file");
	}
else if (File.exists(textPath)) {
     lines=split(File.openAsString(textPath), lineseparator);
     
header = newArray("label e2 e3 e4 x1 y1 x2 y2 e9 e10 e11 e12 e13 e14 e15");
lines = Array.concat(header,lines);

     // recreates the columns headers

     labels=split(lines[0], cellseparator);
     if (labels[0]==" ")
        k=1; // it is an ImageJ Results table, skip first column
     else
        k=0; // it is not a Results table, load all columns

 //    for (j=k; j<labels.length; j++)
 //       setResult(labels[j],0,0);
j=k;
     // dispatches the data into the new RT
     run("Clear Results");
     for (i=1; i<lines.length; i++) {
        items=split(lines[i], cellseparator);
        for (j=k; j<items.length; j++)
           setResult(labels[j],i-1,items[j]);
     }
     updateResults();
	for (row=0; row<nResults; ++row) { 

		bx1=getResult("x1",row);
		by1=getResult("y1",row);;
		bx2=getResult("x2",row);
		by2=getResult("y2",row);
		width=bx2-bx1;
		height=by2-by1;
		labeltype=getResultString("label",row);
		makeRectangle(bx1,by1,width,height);
		roiManager("Add");
		roiManager("select", row)
		roiManager("rename", labeltype);
}
	roiManager("show all with labels")
   if (isOpen("Results"))
   { 
       selectWindow("Results"); 
       run("Close"); 
   }

   
waitForUser("Formerly recorded labels were loaded from .txt file");  
	roiManager("select", 0);

   }

else {
    waitForUser("No label file (.txt or .zip) was found\nin the directory of current image.\n"+
    "You are starting a new labeling job for this image.");
    roiManager("show all with labels")
    }
    



//\\\\\\\\\\\\\\\\\\\\\//





function indexOfArray(array, value) {
    count=0;
    for (a=0; a<lengthOf(array); a++) {
        if (array[a]==value) {
            count++;
        }
    }
    if (count>0) {
        indices=newArray(count);
        count=0;
        for (a=0; a<lengthOf(array); a++) {
            if (array[a]==value) {
                indices[count]=a;
                count++;
            }
        }
        return indices;
    }
}
</macro>
<button> 6 line 1
label=Brought to you by..
icon=kitti label/image4_1.png
arg=<macro>
  
  showMessage("Image Labelling Tool", "<html>"
     +"ImageJ Image Labelling Tool v1.0 for Detectnet datasets<br>"
     +"Macro code concatenated by Alper ALTINOK<br>"
     +"Feel free to modify the code to your needs<br>"
     +"Please keep original author's name, Thanks for using"
     
</macro>
</line>
// end of file
