package com.projectcocoon.p2p.util
{
	import com.projectcocoon.p2p.vo.AccelerationVO;
	import com.projectcocoon.p2p.vo.ClientVO;
	import com.projectcocoon.p2p.vo.MessageVO;
	import com.projectcocoon.p2p.vo.ObjectMetadataVO;
	
	import flash.net.registerClassAlias;

	public class ClassRegistry
	{
		/**
		 * registers the VO classes with the Player VM so objects received
		 * over the NetConnection will be automatically deserialized into
		 * the correct type
		 */
		public static function registerClasses():void
		{
			try
			{
				registerClassAlias("com.projectcocoon.p2p.vo.MessageVO", MessageVO);
			}
			catch (e:Error)
			{
			}
			try
			{
				registerClassAlias("com.projectcocoon.p2p.vo.ClientVO", ClientVO);
			}
			catch (e:Error)
			{
			}
			try
			{
				registerClassAlias("com.projectcocoon.p2p.vo.AccelerationVO", AccelerationVO);
			}
			catch (e:Error)
			{
			}
			try
			{
				registerClassAlias("com.projectcocoon.p2p.vo.ObjectMetadataVO", ObjectMetadataVO);
			}
			catch (e:Error)
			{
			}
		}
	}
}