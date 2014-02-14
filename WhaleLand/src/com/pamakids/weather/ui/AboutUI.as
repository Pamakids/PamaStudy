package com.pamakids.weather.ui
{
    
    import com.pamakids.utils.DeviceInfo;
    import com.pamakids.utils.Screen;
    import com.pamakids.weather.factory.AssetManager;
    import com.pamakids.weather.factory.UICoordinatesFactory;
    import com.pamakids.weather.model.GameData;
    import com.pamakids.weather.model.SoundManager;
    
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    
    import models.PosVO;
    
    import starling.display.Button;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.text.TextField;
    import starling.textures.TextureAtlas;
    import starling.utils.HAlign;
    import starling.utils.VAlign;
    
    public class AboutUI extends Sprite
    {
        
        public var callReturn : Function;
        
        private var recommendBtn : Button;
        private var feedbackBtn : Button;
        private var homeBtn : Button;
        
        private var comIntroduc : TextField;
        private var teamTxt : TextField;
        
        private var bgBmp : Image;
        
        private var oldLangage : String = "cn";
        
        private var resUITextures : TextureAtlas;
        public function AboutUI()
        {
            super();
        }
        
        private var offX:Number=0;
        private var offY:Number=0;
        
        public function installation():void {
            
            new AssetManager
            bgBmp = new Image(AssetManager.getInstance().getTexture("about"));
            bgBmp.x = UICoordinatesFactory.getNewPosX(0);
            //Logger.log("bgBmp.x  :" + bgBmp.x,0);
            addChild(bgBmp);
            
//            offX/=PosVO.scale;
//            offY/=PosVO.scale;
            
            recommendBtn = new Button(AssetManager.getInstance().getTexture("recommend"));
            addChild(recommendBtn);
            recommendBtn.x = UICoordinatesFactory.getNewPosX(615+offX);
            recommendBtn.y = UICoordinatesFactory.getNewPosY(380+offY);
            recommendBtn.addEventListener(TouchEvent.TOUCH,onTouchReCom);
            
            feedbackBtn = new Button(AssetManager.getInstance().getTexture("feedback"));
            addChild(feedbackBtn);
            feedbackBtn.x = UICoordinatesFactory.getNewPosX(496+offX);
            feedbackBtn.y = UICoordinatesFactory.getNewPosY(380+offY);
            feedbackBtn.addEventListener(TouchEvent.TOUCH,onTouchFeedBack);
            
            homeBtn = new Button(AssetManager.getInstance().getTexture("back"));
            addChild(homeBtn);
            homeBtn.addEventListener(Event.TRIGGERED, onClickHomeBtn);
            homeBtn.x = UICoordinatesFactory.getNewPosX(136);
            homeBtn.y = UICoordinatesFactory.getNewPosY(123);
            
            var comFontSize : Number = 17;
            var colSize : Number = 11;
            var teamFontSize : Number = 13;
            if(DeviceInfo.getDeviceType().indexOf("iphone") == -1) {
                comFontSize = 17;
                colSize = 11;
                teamFontSize = 13;
            }else {
                comFontSize = 11.5;
                colSize = 3;
                teamFontSize = 11.5;
            }
            
            var comIntroducStr : String = "";
            comIntroduc = new TextField(550 * Screen.ratio, 200 * Screen.ratio, comIntroducStr, "黑体", comFontSize,0x000000,false,colSize);
            comIntroduc.touchable = false;
            comIntroduc.hAlign = HAlign.LEFT;
            comIntroduc.vAlign = VAlign.TOP;
            addChild(comIntroduc);
            comIntroduc.x = UICoordinatesFactory.getNewPosX(182);
            comIntroduc.y = UICoordinatesFactory.getNewPosY(190);
            
            var teamStr : String = "";
            teamTxt = new TextField(280 * Screen.ratio,130 * Screen.ratio,teamStr,"黑体",teamFontSize,0xFFFFFF,false,6 * Screen.ratio);
            addChild(teamTxt);
            teamTxt.x = UICoordinatesFactory.getNewPosX(200);
            teamTxt.y = UICoordinatesFactory.getNewPosY(450);
            teamTxt.hAlign = HAlign.LEFT;
            teamTxt.vAlign = VAlign.TOP;
            teamTxt.touchable = false;
            
            setTextStr();
            
            switchLangage();
            
            oldLangage = GameData.curLangage;
        }
        
        private function onTouchFeedBack(e:TouchEvent):void 
        {
            var touch : Touch = e.getTouch(feedbackBtn);
            if (touch) {
                if (touch.phase == TouchPhase.ENDED) {
                    navigateToURL(new URLRequest("mailto:hi@pamakids.com"))
                }
            }
        }
        
        private function onTouchReCom(e:TouchEvent):void 
        {
            var touch : Touch = e.getTouch(recommendBtn);
            if (touch) {
                if (touch.phase == TouchPhase.ENDED) {
                    navigateToURL(new URLRequest("http://itunes.apple.com/cn/app//id486386016"))
                }
            }
        }
        
        private function switchLangage():void {
            if (GameData.curLangage == "cn") {
                teamTxt.text = teamStr;
                comIntroduc.text = comIntroCnStr;
            }else {
                comIntroduc.text = comIntroEnStr;
                teamTxt.text = teamStr;
            }
        }
        
        private var teamStr : String;
        private var comIntroCnStr : String;
        private var comIntroEnStr : String;
        private function setTextStr():void {
            if (DeviceInfo.getDeviceType().indexOf("iphone") == -1) {
                teamStr = "Product：@uxdavid  @Pamakids丁然" + "\n";
                teamStr += "Designer：@番薯王小元  @小凡Fiona" + "\n";
                teamStr += "Developer：@icekiller_cn  @Pamakids林硕" + "\n";
                teamStr += "Music: @李星宇Stars  @lazy萱" + "\n";
                teamStr += "Narration：@Peggy_小宇宙 @LynnChaiken";
                comIntroCnStr = "斑马骑士，是一家专注于儿童早期智能教育的科技创业公司。目标通过创意、设计和技术，提供给孩子和父母最专业、最好的教育产品，去激发儿童探索和创造的潜质。基于对心理学、教育学的系统认识和对触摸屏、传感器等交互设计的深刻理解，我们致力以寓教于乐的方式让孩子参与互动操作，充分调动孩子的感官能力和兴趣，来引导他们主动学习。让父母以最省力的方式进行教育管理，有更多的时间精力去陪伴和关爱孩子。";
                comIntroEnStr = "Pamakids Tech Ltd,is an innovation&tech-driven start-up in Beijing,China. We provide creative,professional & the best EDUTAINMENT products for kids & parents.For kids,our products are designed to participate in learning process,to inspire & track their motivations and interests;for parents,are to help manage kids' education activities with ease and joy,to save time for accompanying kids.";
            }else {
                teamStr = "@斑马骑士";
                comIntroCnStr = "斑马骑士，是一家专注于儿童早期智能教育的科技创业公司。目标通过创意、设计和技术，提供给孩子和父母最专业、最好的教育产品，去激发儿童探索和创造的潜质。";
                comIntroEnStr = "Pamakids Tech Ltd,is an innovation and tech-driven start-up in Beijing,China.We provide creative,professional edutainment products for kids & parents.";
            }
        }
        
        public function hide():void {
            this.visible = false;
            comIntroduc.visible = false;
            teamTxt.visible = false;
        }
        
        public function show():void {
            if (oldLangage == GameData.curLangage) {
                
            }else {
                switchLangage();
                oldLangage = GameData.curLangage;
            }
            comIntroduc.visible = true;
            teamTxt.visible = true;
        }
        
        private function onClickHomeBtn(e : Event):void 
        {
            if (this.callReturn != null) {
                this.callReturn();
                SoundManager.getInstance().play("btn_click");
            }
        }
        
        public function destroyed():void {
            bgBmp.dispose();
            comIntroduc.dispose();
            teamTxt.dispose();
        }
    }
}

