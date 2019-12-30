// Action Bar description file :new_action_bar
run("Action Bar","/plugins/ActionBar/new_action_bar.ijm");
exit;

<sticky>
<line>
<button> 1 line 1
label = Name of sel.
bgcolor=2
arg=<macro>
type = selectionType();
	
if (type>-1)
{
roiname = Roi.getName;	
if (roiname=="")
{
waitForUser("This selection is new and not added to the list yet.\nPlease choose 'Add New Selection' button to add it.");
}
else {
roiname = Roi.getName;
waitForUser(roiname);
	}


}

else
waitForUser("No active selection!");

</macro>
</line>


<line>
<button> 2 line 2
label=Add New Sel.
bgcolor=3
arg=<macro>
type = selectionType();
if (type==-1)
{

waitForUser("Please select a region first !");
}

else if (type!=-1)
{
roiname = Roi.getName;

 if (roiname=="")	{
selName = getString("Label:", "");
	if (selName!="") {
	Roi.setName(selName);
	roiManager("add");}
					}

else
{
selName = getString("Re-Label  "+"'"+Roi.getName+"'"+"  to:", "");


	if (selName!="") {
	Roi.setName(selName);
	roiManager("rename", selName);
	roiManager("UseNames","true");
	roiupdater();
	roiManager("show all with labels");}
	else {
	waitForUser("you have to enter a label name!");}
}

}
exit();

function roiupdater() {
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
  	roiupdater();
}
exit();



	function roiupdater() {
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
  	roiManager("update");
}



</macro>
</line>

<line>
<button> 3 line 3
label=close
bgcolor=4
arg=<close>
</line>

<line>
<button> 4 line 4
label=Rotate.CW90
bgcolor=5
arg=<macro>
maintitle=getTitle();
if (isOpen("arrayimage")){
selectWindow("arrayimage");
run("Close");
}
setBatchMode(true);
getwriteroicoord();
roiplus90coords();
setBatchMode(false);
exit();



function getwriteroicoord() {

nroi= roiManager("count");
if (nroi<1) {
waitForUser("There is no roi found in the ROI manager,\ncreate a bounding box first!");exit();
}

newImage("arrayimage", "32-bit black", 4, nroi, 0);
for (i=0; i<nroi; i++) {
roiManager("select", i)	;
Roi.getBounds(x,y,w,h);
boundsarray=newArray(x,y,w,h);
roiManager("Select", i);



selectWindow("arrayimage");

for (xx=0; xx<4; xx++) {
setPixel(xx,i,boundsarray[xx]);
}
selectWindow("arrayimage");
}
}
//---------------------------------------------------
   function roiplus90coords() {
selectWindow(maintitle);
setBatchMode(true);
run("Clear Results");
run("Rotate 90 Degrees Right");
selectWindow("arrayimage");
nroi= getHeight();

for (aroi=0; aroi<nroi; aroi++) {
progres=(aroi/nroi);
showProgress(progres);
selectWindow("arrayimage");
roiManager("select", aroi);
var roiname = Roi.getName;

x=getPixel(0,aroi);
y=getPixel(1,aroi);
w=getPixel(2,aroi);
h=getPixel(3,aroi);

selectWindow(maintitle);
nx=(getWidth()-y)-h;
ny=x;
nw=h;
nh=w;
selectWindow(maintitle);

setBatchMode(true);


            roiManager("Select", aroi);

 			roiManager("measure");

 	for (i=0; i<nResults; i++) {
    oldLabel = getResultLabel(i);
    delimiter = indexOf(oldLabel, ":");
    newLabel = substring(oldLabel, delimiter+1);
    setResult("Label", i, newLabel);
  }
  Roi.setName(newLabel);
  roiManager("rename", newLabel);
//	roiManager("rename", newLabel);
	roiManager("UseNames","true");
	makeRectangle(nx,ny,nw,nh);
	roiManager("update");
	roiManager("show all with labels");
	showProgress(progres);

	}
     if (isOpen("Results")) { 
         selectWindow("Results"); 
         run("Close"); }
	
} 
exit();

</macro>
</line>

//------------------------------------------------------



<line>
<button> 5 line 5
label=Prev. Label
bgcolor=6
arg=<macro>

activeroi=roiManager("index");
lastroi=(roiManager("count")-1);
if (activeroi==-1)  {waitForUser("Select a label first !"); exit();}
else if (activeroi==0)	{
roiupdater();
roiManager("select", lastroi);
	setKeyDown("alt");
	run("To Selection");
	activeroi=lastroi;
	
}

else if (activeroi<=lastroi) {
roiupdater();
activeroi=activeroi-1;
	roiManager("select", activeroi)
	setKeyDown("alt");
	run("To Selection");
	exit();
}

else	{
roiupdater();
roiManager("select", 0);
activeroi=roiManager("index");
	roiManager("select", activeroi)
	setKeyDown("alt");
	run("To Selection");}
exit();

function roiupdater() {
setBatchMode(true);
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
  	roiManager("update");
  	  	//selectWindow("Results");
  	run("Clear Results");
  	   if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   } 
}

</macro>
</line>



<line>
<button> 6 line 6
label=Next Label
bgcolor=7
arg=<macro>
activeroi=roiManager("index");
totalroi=roiManager("count");
if (activeroi==-1) {waitForUser("Select a label first !"); exit();}
else if (activeroi<totalroi-1) {
activeroi=activeroi+1;
roiupdater();
	roiManager("select", activeroi)
	setKeyDown("alt");
	run("To Selection");
}
else	roiManager("select", 0);
activeroi=roiManager("index");
roiupdater();
	roiManager("select", activeroi)
	setKeyDown("alt");
	run("To Selection");
exit();


function roiupdater() {
	setBatchMode(true);
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
  	roiManager("update");
  	//selectWindow("Results");
  	run("Clear Results");
  	   if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   } 
}


</macro>
</line>


<line>
<button> 7 line 7
label=Orig. Scale
bgcolor=1
arg=<macro>
run("Original Scale");
</macro>
</line>

</sticky>
// end of file
