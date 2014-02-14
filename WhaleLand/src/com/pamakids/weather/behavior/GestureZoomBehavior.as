package com.pamakids.weather.behavior
{
	import flash.geom.Point;
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class GestureZoomBehavior implements IBehavior
	{
		
		public var maxScale : Number = 0;
		public var minScale : Number = 0;
		public var callZoomFun : Function;
		public var callTouchFun : Function;
		
		private var mTarget : DisplayObject;
		public function GestureZoomBehavior()
		{
		}
		
		public function register(target:DisplayObject):void
		{
			mTarget = target;
			if(mTarget){
				mTarget.addEventListener(TouchEvent.TOUCH, onTouchHandler);
			}
		}
		
		private function onTouchHandler(e:TouchEvent):void 
		{
			var touches : Vector.<Touch> = e.getTouches(mTarget, TouchPhase.MOVED);
			if (touches.length == 2) {
                var touchA:Touch = touches[0];
                var touchB:Touch = touches[1];
                
                var currentPosA : Point  = touchA.getLocation(mTarget.parent);
                var previousPosA:Point = touchA.getPreviousLocation(mTarget.parent);
                var currentPosB:Point  = touchB.getLocation(mTarget.parent);
                var previousPosB:Point = touchB.getPreviousLocation(mTarget.parent);
                
                var currentVector:Point  = currentPosA.subtract(currentPosB);
                var previousVector:Point = previousPosA.subtract(previousPosB);
                
                var currentAngle:Number  = Math.atan2(currentVector.y, currentVector.x);
                var previousAngle:Number = Math.atan2(previousVector.y, previousVector.x);
                var deltaAngle:Number = currentAngle - previousAngle;
                
				// update pivot point based on previous center
				var previousLocalA:Point  = touchA.getPreviousLocation(mTarget);
				var previousLocalB:Point  = touchB.getPreviousLocation(mTarget);
				//mTarget.pivotX = (previousLocalA.x + previousLocalB.x) * 0.5;
				//mTarget.pivotY = (previousLocalA.y + previousLocalB.y) * 0.5;
				
				// update location based on the current center
				//mTarget.x = (currentPosA.x + currentPosB.x) * 0.5;
				//mTarget.y = (currentPosA.y + currentPosB.y) * 0.5;
				
				// rotate
                //rotation += deltaAngle;

                // scale
                var sizeDiff:Number = currentVector.length / previousVector.length;
				mTarget.scaleX *= sizeDiff;
				mTarget.scaleY *= sizeDiff;
				
				if (minScale > 0) {
					if (mTarget.scaleX <= minScale) {
						mTarget.scaleX = minScale;
						mTarget.scaleY = minScale;
					}
				}
				if (maxScale > 0) {
					if (mTarget.scaleX >= maxScale) {
						mTarget.scaleX = maxScale;
						mTarget.scaleY = maxScale;
					}
				}
				
				if (callZoomFun != null) {
					this.callZoomFun(mTarget.scaleX,mTarget.scaleY);
				}
				
			}else if (touches.length == 1){
				var touch:Touch = touches[0];
			}
			
			if (callTouchFun != null) {
				this.callTouchFun(e);
			}
		
			
		}
		
		public function destroy():void
		{
			if(mTarget){
				mTarget.removeEventListener(TouchEvent.TOUCH, onTouchHandler);
			}
			mTarget = null;
		}
	}
}