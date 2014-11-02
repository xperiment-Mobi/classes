package com.xperiment.make.xpt_interface
{

	import com.Start.WebStart.WebStart;
	import com.xperiment.runner.runner;
	
	import flash.display.Stage;
	import flash.system.Capabilities;
	

	public class StartMaker extends WebStart
	{

		
		public function StartMaker(theStage:Stage, scriptName:String='')
		{
			var nam:String
			
			if(Capabilities.isDebugger==false){
				nam='build.xml';
			}
			else{
				nam=scriptName;
				//<addText  text="a;b" multiline="true" timeStart="0" howMany="2" peg="a---b" x="50%---60%" width="400" background="white---blue" fontSize="80">ii</addText>
			var xml:XML = <Bouba2 exptType="WEB">

 <SETUP>                          
	<screen BGcolour="white" />		  
	<computer stimuliFolder="assets" />
</SETUP>

  <TRIAL TYPE="Trial" hideResults="true" block="1" order="fixed" trials="5" >
	<addText colour="red" howMany="3" text="abc" x="61.38%" y="29.69%---50%---70%" height="28.4%" width="20.1%"  horizontal="right---middle---middle"/>
  </TRIAL>

<TRIAL TYPE="Trial" trialName="DoExpt" hideResults="true" block="1" order="fixed" trials="1">
	
	<addText howMany="10" x="10%---20%---etc---" y="20%---25%---etc---" width="5%" height="5" text="123" vertical="bottom" ttimeStart="0" timeStart="0---200---300---400" timeEnd="600" />		
	<addJPG filename="new.png" />
	<addButton width="140" howMany="2" sstartID="next" height="40" text="I consent" resultFileName="continue" timeEnd="forever" x="50%---60%---70%"  y="90%"/>


</TRIAL>

<TRIAL TYPE="Trial" trialName="DoExpt" hideResults="true" block="2" order="fixed" trials="2">
		
	<addText  text="c;d" multiline="true" timeStart="0" howMany="2" peg="c---d" x="50%---60%" width="400" background="white---blue" fontSize="80"/>
	<addButton width="140" sstartID="next" height="40" text="I consent" resultFileName="continue" timeStart="0" timeEnd="forever" x="50%"  y="90%"/>

</TRIAL>

</Bouba2>	

/*		<t>
			<s>bla</s>
			<s>alb</s>
		</t>
		<t>hello</t>*/

/*xml = <Taste exptType="WEB">

<SETUP>  
			  <info id="c856865c45b64f2da6ecde2bf0962a24" />
			  <results  mock="false" />
			  <screen BGcolour="0x7A7A79" orientation="horizontal" ></screen>                          
			  <computer  stimuliFolder="OxfordShapeTaste" />
			  <trials blockDepthOrder="20,*=random" />
			  <style  LABEL_TEXT="0x000000" />
</SETUP>


<TRIAL TYPE="Trial"  hideResults="true" block="0" order="fixed" trials="1">

		<addJPG y="0%" vertical="top" filename="lab.png" exactSize="true" width='600' height='108'  />

		<addText  y="50%" x="50%" wordWrap="true" colour="white" align="left"  autoSize="false" width="100%" height="80%"  timeStart="0" fontSize="20"
	text="Welcome to our study! We are the Crossmodal Research Laboratory, Department of Experimental Psychology, Oxford University. 
We are interested in understanding how people associate information across the senses. If you decide to take part in this experiment, you will be asked to match a variety of shapes to tastes. 
There are not right or wrong responses, please respond according to what it feels right to you. We hope you enjoy it. Your participation is very important to us."/>   
	
	<addButton peg="next" timeStart="0" width="350" enabled="false" height="200" text="Continue" resultFileName="continue" horizontal="right" x="99%" y="99%" vertical="bottom" ></addButton>                

	<addText  y="83%" x="5%" wordWrap="true" align="left"  horizontal="left" autoSize="true" width="40%" height="10%"  timeStart="0" fontSize="20"
	text="When the stimuli have loaded (below bar), please click 'Continue'"/>    
	<addLoadingIndicator behaviours='onFinish:next.enabled=true' width="50%" height="5%" x="30%" y="91%" />
</TRIAL>



<TRIAL TYPE="Trial" block="3" order="fixed" trials="1">
	<fullScreen timeStart="0" if="this.onFinish?next.start()"/>
	<behavNextTrial peg="next" />
	
	
</TRIAL>

<TRIAL TYPE="Trial" block="3" order="fixed" trials="1">

	<addUrlVariable  _ip="notGiven" />

	<addText   x="50%" y="12%" height="20%"
	text = "some questions"
	timeStart="0"  width="80%" timeEnd="forever" fontSize="20"></addText> 
	
	<addText howMany="2" width="60" height="10%" x="20%" y="23%---40%" 
	text="sex---age"
	timeStart="0"  timeEnd="forever" autoSize="false" align="right" fontSize="20"/> 

	<addMultipleChoice peg="sex" distanceApart="5" width="25%" height="10%" horizontalDistanceApart="210" 
	labels="male,female"
	x="50%" y="20%" timeStart="0"  timeEnd="forever" /> 	
	
	<addMultiNumberSelector peg="age" width="25%" height="20%" startingVal="00"  x="50%" y="40%" timeStart="0" timeEnd="forever" />

	<addComboBox peg="origin" 
	label="where do you come from?"
	timeStart="0" width="70%" height="40%" vertical="top" timeEnd="forever" x="50%" y="58%"/>
	
	<addInput text="what is your native language? Please type your answer into this box." timeStart="0" peg="language" height="7%" y="76%" width="70%"/>

	<behavNextTrial peg='nextTrial'/>
	
	<addButton timeStart='0' hideResults="true" width="340" goto='' height="40" peg='next' 
	text="next"
	if="this.click?this.text='please answer the questions',this.click&&language.result!=''&&origin.result!=''&&age.result!=''?nextTrial.start()"  
	timeEnd="forever" x="50%" vertical="top" y="90%"/>
	
</TRIAL>

<TRIAL TYPE="Trial" block="3" order="fixed" trials="1">

<addText  y="50%" x="50%" wordWrap="true" colour="white" align="left"  autoSize="false" width="100%" height="80%"  timeStart="0" fontSize="30"
	text="You will now begin the experiment. Every two trials you will taste a new drink. Before doing so, please cleanse your palate with water."/>   
	<addButton timeStart='0' hideResults="true" width="340" height="40" text="begin" x="50%" vertical="top" y="90%"/>
	
</TRIAL>


<TRIAL template="templatePause" TYPE="Trial" block="20,2" order="fixed" forceBlockDepthPositions="2"/>
<TRIAL template="templatePause" TYPE="Trial" block="20,3" order="fixed" forceBlockDepthPositions="4"/>
<TRIAL template="templatePause" TYPE="Trial" block="20,4" order="fixed" forceBlockDepthPositions="6"/>
<TRIAL template="templatePause" TYPE="Trial" block="20,5" order="fixed" forceBlockDepthPositions="8"/>
<TRIAL template="templatePause" TYPE="Trial" block="20,6" order="fixed" forceBlockDepthPositions="10"/>
<TRIAL template="templatePause" TYPE="Trial" block="20,7" order="fixed" forceBlockDepthPositions="12"/>
<TRIAL template="templatePause" TYPE="Trial" block="20,8" order="fixed" forceBlockDepthPositions="14"/>
<TRIAL template="templatePause" TYPE="Trial" block="20,9" order="fixed" forceBlockDepthPositions="16"/>
<TRIAL template="templatePause" TYPE="Trial" block="20,10" order="fixed" forceBlockDepthPositions="18"/>


<TRIAL block="20,1,1" template="templateLineScale" trialName="t"><addText copyOverID="taste" text1="143" taste="bitterW"/></TRIAL>

<TRIAL block="20,2,1" template="templateLineScale" trialName="t"><addText copyOverID="taste" text1="215" taste="bitterS"/></TRIAL>
<TRIAL block="20,3,1" template="templateLineScale" trialName="t"><addText copyOverID="taste" text1="244" taste="sourW"/></TRIAL>

<TRIAL block="20,4,1" template="templateLineScale" trialName="t"><addText copyOverID="taste" text1="384" taste="sourS"/></TRIAL>
<TRIAL block="20,5,1" template="templateLineScale" trialName="t"><addText copyOverID="taste" text1="455" taste="sweetW"/></TRIAL>

<TRIAL block="20,6,1" template="templateLineScale" trialName="t"><addText copyOverID="taste" text1="466" taste="sweetS"/></TRIAL>
<TRIAL block="20,7,1" template="templateLineScale" trialName="t"><addText copyOverID="taste" text1="506" taste="saltyW"/></TRIAL>

<TRIAL block="20,8,1" template="templateLineScale" trialName="t"><addText copyOverID="taste" text1="618" taste="saltyS"/></TRIAL>

<TRIAL block="20,9,1" template="templateLineScale" trialName="t"><addText copyOverID="taste" text1="688" taste="umamiM"/></TRIAL>
<TRIAL block="20,10,1" template="templateLineScale" trialName="t"><addText copyOverID="taste" text1="712" taste="umamiS"/></TRIAL>




<templateLineScale order="random" trials="2">
	
	<addText  copyOverID="taste" align="centre" timeStart="0" peg="instruct" width="100%" height="20%" x="50%" y="0" vertical="top" verticalAlign="top"
	text="Please indicate where on the scale you would place a mark to represent the taste {b}" text1="" text2="{/b}. Click on the scale and move the mark to do so." 
	fontSize="40" wordWrap="true" timeEnd="forever" /> 
	
	<addResults if="this.doBefore?this.type=instruct.text1,this.im1=i1.filename,this.im2=i2.filename,this.taste=instruct.taste"/>

	<addJPG exactSize="true" timeStart="0" peg="i1---i2" howMany="2" filename="kiki.png---bouba.png;rounded1.png---angular1.png"	
	x="5%---95%" y="45%" horizontal="left---right"/>
	
	<linescale timeStart="0" peg="scale" if="this.updated?liking.start()" y="30%" labelList="," width="70%"/>
	
	<linescale howMany="2" peg="intensity---liking"  if="this.updated?b.start()---this.updated?intensity.start()" labelList="not intense,very intense---not liked at all,very much liked" y="85%---65%"  width="70%"/>
	
	<addButton  peg="b" hideResults="true" key=" " y="100%" vertical="bottom" width="200" height="40" text="next (space bar)"/>
	
	<behavNextTrial peg='nextTrial'/>
</templateLineScale>  

<templatePause  order="fixed" trials="1">
	<addText  y="50%" x="50%" wordWrap="true" colour="white" align="left"  autoSize="false" width="100%" height="80%"  timeStart="0" fontSize="30"
	text="Now, you will answer questions about a new taste. Before doing so, we will ask you to cleanse your palate with water."/>   
	<addButton key=" " timeStart='0' hideResults="true" width="340" height="40" text="begin" x="50%" vertical="top" y="90%"/>
</templatePause>


			
<TRIAL TYPE="Trial" hideResults="true" block="100" order="fixed" trials="1">
		  
	<behavSaveData timeStart='0'/>
	
	<addText  wordWrap="true"  height="30%" width="100%" x="50%" y="50%" 
	text = "Thank you for your participation to this study." timeStart="0"  timeEnd="forever" fontSize="25"></addText> 
	
</TRIAL>




</Taste>	
*/
/*<TRIAL  TYPE="Trial" hideResults="true" block="20" order="fixed" trials="1">
		
		  

	<addText wordWrap="true" height="30%" width="100%" x="50%" y="65%" text=
	"Thank you for your participation. Have a lovely day! Don't forget to enter the below code in Mechanical Turk."
	timeStart="0"  timeEnd="forever" fontSize="20"></addText> 
	

		 <addText copyOverID="stim" autoSize="false" wordWrap="true" fontSize="20" width="95%" height="80%" x="50%" y="0%" vertical="top" text=
"{b}What we were testing.{/b}"
timeStart="0"  timeEnd="forever"></addText> 
	

</TRIAL>
*/
	
			
			}
			
			super(theStage,nam);
			
			if(nam==""){
				startExpt(xml);
			}
			
		}
		
		override public function exptPlatform():runner{
			return new runnerBuilder(theStage);
		}
		

	}
}