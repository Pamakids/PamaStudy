package com.pamakids.weather.factory
{
    import com.pamakids.utils.DeviceInfo;
    import com.pamakids.utils.Screen;
    
    import flash.geom.Point;
    
    public class UICoordinatesFactory
    {
        public static const START_LOADING : String = "startloading";
        
        
        private static var instance : UICoordinatesFactory;
        public function UICoordinatesFactory()
        {
        
        }
        
        public static function getInstance():UICoordinatesFactory {
            if (instance == null) {
                instance = new UICoordinatesFactory();
            }
            return instance;
        }
        
        public static function getNewPosX(value : Number):Number {
            return value * Screen.ratio;
        }
        public static function getNewPosY(value : Number):Number {
            return value * Screen.ratio;
        }
        
        public function getUIPostion(name : String):Point {
            switch(name){
                case START_LOADING :
                    return getStartLoadingPos();
                    break;
                default :
                    return new Point(0,0);
                    break;
                
            }
        }
        
        private function getStartLoadingPos() : Point {
            if (DeviceInfo.getDeviceType().indexOf("iphone") == -1) {
                return new Point(275,100);
            }else {
                return new Point(0,50);
            }
        }
    }
}

