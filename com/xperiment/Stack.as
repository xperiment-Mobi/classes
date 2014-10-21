package com.xperiment
{
	public class Stack
	{
		private var head:StackNode;
		
		public function push(obj:Object):void
		{
			var newNode:StackNode = new StackNode(obj);
			
			if(head == null)
				head = newNode;
			else
			{
				newNode.next = head;
				head = newNode;
			}
		}
		
		public function pop():Object
		{
			if(head != null)
			{
				var result:Object = head.value;
				head = head.next;
				
				return result;
			}
			else
				return null;
		}
		
		public function peek():Object
		{
			if(head != null)
				return head.value;
			else
				return null;
		}
	}
}