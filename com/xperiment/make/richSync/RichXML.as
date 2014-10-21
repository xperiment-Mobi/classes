package com.xperiment.make.richSync
{
	public class RichXML extends RichStr
	{
		/*
		 * This class has limited scope! It allows you to preserve line spacing, comments etc whilst allowing for:
		 * 1. modification of the content of nodes within Xperiment
		 * 2. deletion of a node
		 * 3. adding of a node
		 *
		 * How it works:
		 * 1a. Accepts XML and then populates that XML with line tags _L="1".  This XML is then used by Xperiment.  Any changes to the XML can now be updated via the line tags
		 * 1b. Updating simply done by passing whole XML back into updateWithXML function :)		
		 * 2. When asked for via composeUpdatedLines() (in richStr), outputs the original lines + updates WITHOUT the line tags.
		 *
		 * The process:
		 * Thus, Xperiment is given a rich String (by django).  That rich String is processed into an xml. Xml can be modified by XPT. 
		 * When requested via updateWithXML function, modifications are imposed on original rich string which can be passed to JS. 
		 * JS can then pass back a similar rich string and the process begins again.
		 *
		 * The future:	
		 * Would it be advantageous to preserve this class's data over above cycles?  Not convinced.
		 */
		
		
		
		
		
		private var _originalXML:XML;
		
		public function composeXML():XML
		{	
			var lines:String = _composeLabelledLines();
			//XML.prettyPrinting=false;

			
			try{
				_originalXML = XML(lines);
			}
			catch(e:Error){
				throw new Error('devel error in parsing labelld XML');
			}
			
			return _originalXML;
		}
		
		public function updateWithXML(updatedXML):void{
			_updateWithStr(updatedXML.toString());
		}
		
		
		

	}
}