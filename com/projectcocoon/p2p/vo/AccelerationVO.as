package com.projectcocoon.p2p.vo
{
	

	/**
	 * Stores acceleration information 
	 */
	public class AccelerationVO
	{
		
		public var client:ClientVO;
		public var accelerationX:Number;
		public var accelerationY:Number;
		public var accelerationZ:Number;
		public var timestamp:Number;
		
		public function AccelerationVO(client:ClientVO = null, accelerationX:Number = Number.NaN, accelerationY:Number = Number.NaN, accelerationZ:Number = Number.NaN, timestamp:Number = Number.NaN)
		{
			this.client = client;
			this.accelerationX = accelerationX;
			this.accelerationY = accelerationY;
			this.accelerationZ = accelerationZ;
			this.timestamp = timestamp;
		}
		
	}
}