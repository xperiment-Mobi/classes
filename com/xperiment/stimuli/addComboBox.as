package com.xperiment.stimuli
{

	import com.bit101.components.ComboBox;
	import com.bit101.components.Style;
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.primitives.IResult;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	
	public class addComboBox extends object_baseClass implements Imockable, IResult
	{
			
		protected var comboBox:ComboBox;
		
		override public function kill():void{
			if(pic && pic.contains(comboBox))pic.removeChild(comboBox);
			comboBox=null;
			super.kill();
		}

		
		public function mock():void{
			
			var arr:Array = comboBox.items;			
			comboBox.selectedItem =codeRecycleFunctions.arrayShuffle(arr)[0];
		}
		
		override public function myUniqueProps(prop:String):Function{
			uniqueProps ||= new Dictionary;
			if(uniqueProps.hasOwnProperty('result')==false){
				uniqueProps.result= function():String{
										//AW Note that text is NOT set if what and to and null. 
										var result:String = comboBox.selectedItem as String;
										if(result) return "'"+result+"'";
										return "''";
									}; 	
			}
			
			
			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop]
			return super.myUniqueProps(prop);
		}
		

		override public function storedData():Array {
			var tempData:Array = new Array();
			tempData.event=peg;
			tempData.data=comboBox.selectedItem as String;
			if(tempData.data==null)tempData.data='';
			super.objectData.push(tempData);
			return objectData;
		}
		
		override public function returnsDataQuery():Boolean {return true;}
		
		override public function setVariables(list:XMLList):void 
		{
			setVar("string","items","United States,United Kingdom,Ireland,France,Afghanistan,Albania,Algeria,American Samoa,Andorra,Angola,Anguilla,Antarctica,Antigua and Barbuda,Argentina,Armenia,Aruba,Australia,Austria,Azerbaijan,Bahamas,Bahrain,Bangladesh,Barbados,Belarus,Belgium,Belize,Benin,Bermuda,Bhutan,Bolivia,Bosnia and Herzegovina,Botswana,Bouvet Island,Brazil,British Indian Ocean Territory,Brunei Darussalam,Bulgaria,Burkina Faso,Burundi,Cambodia,Cameroon,Canada,Cape Verde,Cayman Islands,Central African Republic,Chad,Chile,China,Christmas Island,Cocos (Keeling) Islands,Colombia,Comoros,Congo,The Democratic Republic of The Congo,Cook Islands,Costa Rica,Cote D'ivoire,Croatia,Cuba,Cyprus,Czech Republic,Denmark,Djibouti,Dominica,Dominican Republic,Ecuador,Egypt,El Salvador,Equatorial Guinea,Eritrea,Estonia,Ethiopia,Falkland Islands (Malvinas),Faroe Islands,Fiji,Finland,France,French Guiana,French Polynesia,French Southern Territories,Gabon,Gambia,Georgia,Germany,Ghana,Gibraltar,Greece,Greenland,Grenada,Guadeloupe,Guam,Guatemala,Guinea,Guinea-bissau,Guyana,Haiti,Heard Island and Mcdonald Islands,Holy See (Vatican City State),Honduras,Hong Kong,Hungary,Iceland,India,Indonesia,Iran - Islamic Republic of,Iraq,Ireland,Israel,Italy,Jamaica,Japan,Jordan,Kazakhstan,Kenya,Kiribati,Korea - Democratic People's Republic of,Korea,Kuwait,Kyrgyzstan,Lao People's Democratic Republic,Latvia,Lebanon,Lesotho,Liberia,Libyan Arab Jamahiriya,Liechtenstein,Lithuania,Luxembourg,Macao,Macedonia,The Former Yugoslav Republic of,Madagascar,Malawi,Malaysia,Maldives,Mali,Malta,Marshall Islands,Martinique,Mauritania,Mauritius,Mayotte,Mexico,Micronesia,Moldova,Monaco,Mongolia,Montserrat,Morocco,Mozambique,Myanmar,Namibia,Nauru,Nepal,Netherlands,Netherlands Antilles,New Caledonia,New Zealand,Nicaragua,Niger,Nigeria,Niue,Norfolk Island,Northern Mariana Islands,Norway,Oman,Pakistan,Palau,Palestine,Palestinian Territory,Panama,Papua New Guinea,Paraguay,Peru,Philippines,Pitcairn,Poland,Portugal,Puerto Rico,Qatar,Reunion,Romania,Russian Federation,Rwanda,Saint Helena,Saint Kitts and Nevis,Saint Lucia,Saint Pierre and Miquelon,Saint Vincent and The Grenadines,Samoa,San Marino,Sao Tome and Principe,Saudi Arabia,Senegal,Serbia and Montenegro,Seychelles,Sierra Leone,Singapore,Slovakia,Slovenia,Solomon Islands,Somalia,South Africa,South Georgia and The South Sandwich Islands,Spain,Sri Lanka,Sudan,Suriname,Svalbard and Jan Mayen,Swaziland,Sweden,Switzerland,Syrian Arab Republic,Taiwan,Province of China,Tajikistan,Tanzania,Thailand,Timor-leste,Togo,Tokelau,Tonga,Trinidad and Tobago,Tunisia,Turkey,Turkmenistan,Turks and Caicos Islands,Tuvalu,Uganda,Ukraine,United Arab Emirates,United Kingdom,United States,United States Minor Outlying Islands,Uruguay,Uzbekistan,Vanuatu,Venezuela,Viet Nam,Virgin Islands,Virgin Islands - British,Wallis and Futuna,Western Sahara,Yemen,Zambia,Zimbabwe");
			setVar("number", "itemHeight",30);
			setVar("number", "buttonHeight",50);
			setVar("number", "itemHeight",50);
			setVar("number","fontSize",16);
			setVar("uint","numberOfItemsShown",0);
			setVar("string","label","label");
			setVar("string","menuColour",Style.BUTTON_FACE);
			super.setVariables(list);
		}
		
		protected function createStim():void
		{
			comboBox = new ComboBox(getVar("items").split(","),getVar("label"),myWidth,myHeight,getVar("fontSize"),getVar("buttonHeight"),getVar("itemHeight"),codeRecycleFunctions.getColour(getVar("menuColour")));
			
			comboBox.listItemHeight=getVar("itemHeight") as Number;
			
			
			if(getVar("numberOfItemsShown")!=0)comboBox.numVisibleItems=getVar("numberOfItemsShown");
			
			
	
			pic.graphics.clear();
			pic.addChild(comboBox);
			

		}
		
		override public function drawMovePoint(xPos:int,yPos:int,col:Number):void{
			var myPoint:Point = pic.localToGlobal(new Point(comboBox.x,comboBox.y));
			super.drawMovePoint(myPoint.x,myPoint.y,col);
		}
		
	
		override public function RunMe():uberSprite {
			pic.graphics.drawRect(0,0,1,1); //needs to have A size as setUniversalVariables does resizing and cannot resize 
			super.setUniversalVariables();
			
			createStim();
			
			
			pic.scaleX=1;
			pic.scaleY=1;

			

			return (super.pic);
		}
		
		
		

	}
}