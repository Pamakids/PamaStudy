package com.pamakids.weather.ui
{
    import com.pamakids.uimanager.UIBase;
    import com.pamakids.utils.Screen;
    import com.pamakids.weather.factory.AssetManager;
    import com.pamakids.weather.factory.BitmapDataLibrary;
    import com.pamakids.weather.factory.UICoordinatesFactory;
    import com.pamakids.weather.model.GameData;
    import starling.display.Button;
    import starling.display.Image;
    import starling.events.Event;
    import starling.textures.Texture;
    
    public class WishListUI extends UIBase
    {
        private var wlistBg : Image;
        //returnBtn
        private var returnBtn : Button;
        
        private var medalNum : int = 11;
        private var medalList : Array = [ ];
        public function WishListUI()
        {
            super();
        }
        
        public function init():void {
            
            setTexture();
            
            //bg
            wlistBg = new Image(wlistBgTexture);
//			wlistBg.x = Screen.offX;
            addChild(wlistBg);
            //backBtn
            returnBtn = new Button(returnBtnTexture);
            addChild(returnBtn);
            returnBtn.x = UICoordinatesFactory.getNewPosX(106);
            returnBtn.y = UICoordinatesFactory.getNewPosY(112);
            returnBtn.addEventListener(Event.TRIGGERED, onReturnHandler);
            //勋章
            for (var i : int = 0; i < medalNum; i ++ ) {
                //底下的灰色层
                var medal : Image = new Image(meadalTextures[i]);
                addChild(medal);
                medal.alpha = 0.7;
                medal.touchable = false;
                medal.x = UICoordinatesFactory.getNewPosX(164) + 192 * (i % 4) ;
                medal.y = UICoordinatesFactory.getNewPosY(130) + 176 * (int(i / 4)) ;
                setDefaultColor(medal);
                changeColor(medal);
                //上部
                var tmedal : Image = new Image(meadalTextures[i]);
                addChild(tmedal);
                tmedal.touchable = false;
                tmedal.alpha = 0.2;
                tmedal.x = UICoordinatesFactory.getNewPosX(164) + 192 * (i % 4) ;
                tmedal.y = UICoordinatesFactory.getNewPosY(130) + 176 * (int(i / 4)) ;
                medalList[i] = tmedal;
            }
            
            updateMedalState();
        
        }
        
        private var wlistBgTexture : Texture;
        private var returnBtnTexture : Texture;
        private var meadalTextures : Vector.<Texture>;
        private function setTexture():void {
            wlistBgTexture = AssetManager.getInstance().getTexture("wlistback");
            returnBtnTexture = AssetManager.getInstance().getTexture("back");
            meadalTextures = AssetManager.getInstance().getTextures("xunzhang");
        }
        
        
        private function updateMedalState():void {
            var curList : Array = GameData.getCurWish();
            trace("当前的愿望是 : " + curList);
            
            for (var i : int = 0; i < medalList.length; i ++ ) {
                for (var j : int = 0; j < curList.length;j ++ ) {
                    if (curList[j] == i) {
                        medalList[i].alpha = 1;
                    }
                }
            }
        }
        
        public function destroy():void {
            wlistBg.dispose();
            returnBtn.dispose();
            this.removeChildren();
            this.removeEventListeners();
            medalList = [];
        }
        
        private function setDefaultColor(obj : Image):void {
            obj.data.defaultColor = obj.color;
        }
        
        private function changeColor(obj : Image,model : int = 0):void {
            if (model == 0) {
                obj.color = 0x000000;
                obj.alpha = 0.6;
            }else if (model == 1) {
                obj.color = obj.data.defaultColor;
                obj.alpha = 1;
            }
        }
        
        private function onReturnHandler(e:Event):void 
        {
            destroy();
        }
    
    }
}

