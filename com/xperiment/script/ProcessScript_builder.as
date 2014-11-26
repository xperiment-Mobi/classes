package com.xperiment.script
{
	import com.xperiment.make.xpt_interface.Bind.BindScript;

	public class ProcessScript_builder extends ProcessScript
	{
		

		
		
		override protected function setVal(templateAttribs:XMLList, childMain:XML):void
		{
			var nam:String;
			for each(var attribute:XML in templateAttribs) {
				nam=attribute.name()
				if(childMain.hasOwnProperty("@"+nam)==false){
					if(nam!=BindScript.templateBindLabel)	childMain.@[nam]=attribute;
					else{
						childMain.@[BindScript.bindLabel]= childMain.@[BindScript.bindLabel].toString()+","+attribute;
						giveChildrenBinding(childMain,attribute);
					}
					
				}

			}
			
		}
		
		private function giveChildrenBinding(parent:XML, attribute:XML):void
		{
			for each(var xml:XML in parent.children()){
				if(xml.hasOwnProperty('@'+COPYOVER_ID)){
					xml.@[BindScript.bindLabel]= xml.@[BindScript.bindLabel].toString()+","+attribute;
				}
			}
			
		}
	}
}