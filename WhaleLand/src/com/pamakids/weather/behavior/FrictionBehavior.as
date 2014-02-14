package com.pamakids.weather.behavior
{
    import models.PosVO;
    
    import starling.display.DisplayObject;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    
    public class FrictionBehavior implements IBehavior
    {
        public var callFun:Function;
        public var callTouchFun:Function;
        public var maxFricLen:Number=0;
        private var mTarget:DisplayObject;
        private var fricLen:Number=0;
        
        public function FrictionBehavior()
        {
        
        }
        
        public function register(target:DisplayObject):void
        {
            mTarget=target;
            if (mTarget)
            {
                mTarget.addEventListener(TouchEvent.TOUCH, onTouchHandler);
            }
        }
        
        private function onTouchHandler(e:TouchEvent):void
        {
            var touch:Touch=e.getTouch(mTarget);
            if (touch)
            {
                if (touch.phase == TouchPhase.BEGAN)
                {
                    
                }
                else if (touch.phase == TouchPhase.MOVED)
                {
                    var dy:int=touch.globalY - touch.previousGlobalY;
                    var dx:int=touch.globalX - touch.previousGlobalX;
                    fricLen+=(Math.abs(dx) + Math.abs(dy));
                    if (fricLen >= maxFricLen)
                    {
                        fricLen=0;
                        if (this.callFun != null)
                        {
                            this.callFun(fricLen);
                        }
                    }
                }
                else if (touch.phase == TouchPhase.ENDED)
                {
                    fricLen=0;
                }
                
                if (this.callTouchFun != null)
                {
                    this.callTouchFun(e);
                }
                
            }
        }
        
        public function enabled():void
        {
            mTarget.touchable=true;
            mTarget.addEventListener(TouchEvent.TOUCH, onTouchHandler);
        }
        
        public function destroy():void
        {
            fricLen=0;
            mTarget.touchable=false;
            mTarget.dispose();
            //mTarget.removeEventListener(TouchEvent.TOUCH,onTouchHandler);
        }
    }
}


