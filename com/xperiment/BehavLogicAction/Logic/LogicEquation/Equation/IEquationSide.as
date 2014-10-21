package com.xperiment.BehavLogicAction.Logic.LogicEquation.Equation
{
	/**
	 * @flowerModelElementId _9kH8kDfJEeKW7cM3ixcl0w
	 */
	public interface IEquationSide
	{		function get equation():*;
		function set equation(value:*):void;
		function get equationOrigStr():String;
		function set equationOrigStr(what:String):void;
		function update(what:String,toWhat:*):void;
		function get equationNegated():Boolean; 
		function set equationNegated(value:Boolean):void;
		function requestUpdates(updateDicts:Function):void;
		function equationNow(orig:Boolean=true):*;
		function updateNow():void;
		function kill():void;
	}
}