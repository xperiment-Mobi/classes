package com.xperiment.Code.Interpretter
{
	
	import com.xperiment.PythonScript.nodes.AddNode;
	import com.xperiment.PythonScript.nodes.AtomNode;
	import com.xperiment.PythonScript.nodes.CompNode;
	import com.xperiment.PythonScript.nodes.DivNode;
	import com.xperiment.PythonScript.nodes.LookupNode;
	import com.xperiment.PythonScript.nodes.MulNode;
	import com.xperiment.PythonScript.nodes.PowNode;
	import com.xperiment.PythonScript.nodes.PropertyCallNode;
	import com.xperiment.PythonScript.nodes.SLNode;
	import com.xperiment.PythonScript.nodes.SLValue;
	import com.xperiment.PythonScript.nodes.SubNode;
	import com.xperiment.PythonScript.nodes.UnaryNode;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import org.antlr.runtime.ANTLRFileStream;
	import org.antlr.runtime.ANTLRStringStream;
	import org.antlr.runtime.CharStream;
	import org.antlr.runtime.CommonTokenStream;
	import org.antlr.runtime.ParserRuleReturnScope;
	import org.antlr.runtime.tree.CommonTree;
	import org.antlr.runtime.tree.CommonTreeNodeStream;
	
	import test.ExpressionTest;
	import test.TestBase;
	
	
	public class Interpretter
	{
		

		private static var tokens:CommonTokenStream;
		private static var _astTA:Object;
		private var myLoader:URLLoader;
		private var code:ANTLRStringStream;
		private var input:String;
		private var lexer:JS_AWLexer;
		private var parser:JS_AWParser;
		private var walker:TreeWalker;
		
		public function Interpretter()
		{
			init();
		}
		
		private function init():void
		{
			this.input = "1+1";
			code = new ANTLRStringStream(input);
			
			lexer = new JS_AWLexer(code);
			parser = new JS_AWParser(new CommonTokenStream(lexer));		
			var tree:Object = parser.expression().tree;
			
			var nodes:CommonTreeNodeStream = new CommonTreeNodeStream(tree);
	
			walker = new TreeWalker(nodes);
			
			var node:SLNode = walker.expression();
			var value:SLValue = node.evaluate();
			
			trace(value.asString(),22)
			
		}
	}
}