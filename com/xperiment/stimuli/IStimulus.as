package com.xperiment.stimuli
{

	import com.xperiment.uberSprite;
	import com.xperiment.behaviour.BehaviourBoss;

	public interface IStimulus
	{
		
		function giveBehavBoss(manageBehaviours:BehaviourBoss):void;
		function setUpTrialSpecificVariables(trialObjs:Object):void;
		function setVariables(list:XMLList):void;
		function returnsDataQuery():Boolean;
		function getVar(str:String):*;
		function RunMe():uberSprite;
		
	}
}