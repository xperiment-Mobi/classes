package com.xperiment.make.xpt_interface.trialDecorators.StimBehav
{
	import com.xperiment.behaviour.BehaviourBoss;
	import com.xperiment.behaviour.abstractBehaviourBoss;
	import com.xperiment.stimuli.object_baseClass;
	
	import flash.utils.Dictionary;

	public class PropsEventsActions
	{

		public static function extract(stimulus:object_baseClass, info:Object):void
		{

			info.editableProps = 	getEditableProps(stimulus);
			//info.Props is extractable elsewhere
			info.events 	   = 	getEvents(stimulus);
			info.actions	   =	getActions(stimulus);
			//trace(stimulus,JSON.stringify(info));
		}
		
		private static function getActions(stimulus:object_baseClass):Array
		{
			stimulus.myUniqueActions('');
			var actions:Array = populate(stimulus,stimulus.uniqueActions,stimulus.disallowedActions,BehaviourBoss.permittedActions);
			stimulus.uniqueProps=null;

			return actions;
		}
		
		private static function getEvents(stimulus:object_baseClass):Array
		{
			return populate(stimulus, stimulus.uniqueEvents,stimulus.disallowedEvents,abstractBehaviourBoss.availEvents);
		}		
		

		private static function getEditableProps(stimulus:object_baseClass):Array
		{
			
			stimulus.myUniqueProps('');
			var props:Array = populate(stimulus, stimulus.uniqueProps,stimulus.disallowedProps,BehaviourBoss.permittedEditableProps);
			stimulus.uniqueProps=null;
			return props;
		}	
		

		private static function populate(stimulus:object_baseClass,stimUnique:Dictionary,disallowed:Vector.<String>,generic:Vector.<String>):Array{
			var arr:Array = [];
			var key:String;
			
			var reminder:Vector.<String> = new Vector.<String>;
			
			//gather unique editable properties
			for(key in stimUnique){
				arr.push( {name:key, info:''} );	 
				reminder[reminder.length]=key;
			}
			stimulus.uniqueProps=null;
			//

			
			//gather generic editable properties
			for each(key in generic){
				if(disallowed && disallowed.indexOf(key)!=-1)''
				else{
					if(reminder.indexOf(key)==-1){
						arr.push( {name:key, info:''} );
						reminder[reminder.length]=key;
					}
				}
			}
			//
			arr.sortOn("name",Array.CASEINSENSITIVE);
			
			return arr;
		}
		
		
		
	}
}