/**
 * Created by Andy on 16/12/2014.
 */
package com.xperiment.behaviour {

public class behavPixelEater extends behav_baseClass {

    public function behavPixelEater() {
    }


    override public function setVariables(list:XMLList):void {
        setVar("string","save","","x or y or xy");
        setVar("string","saveProperty","","you can use an stimulus's property (if it does NOT have the property, 0-x [in order they were given in usePegs] will be used as a failsafe)");
        setVar("boolean","restrictToScreen",true);
        setVar("string","box","");
        super.setVariables(list);

    }

    override public function nextStep(id:String=""):void{
        pic.graphics
    }


    override public function returnsDataQuery():Boolean {
       return true;
    }

    override public function storedData():Array {

       // if(sav.indexOf("x")!=-1)	objectData.push({event:nam+".x",data:int(stim.x)});

       return objectData;
    }

}
}
