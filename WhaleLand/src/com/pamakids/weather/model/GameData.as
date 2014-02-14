package com.pamakids.weather.model
{
    import com.pamakids.core.PluginControl;
    import com.pamakids.core.msgs.LightIconMsg;
    import com.pamakids.utils.Screen;
    import com.pamakids.weather.items.SnowManShow;
    
    import flash.geom.Point;
    public class GameData
    {
        public static var trackList : Array = [[0,275],[255,150],[535,100],[795,130],[1020,210],[1220,350]];
        public static var trackKList : Array = [];
        public static var trackBList : Array = [];
        
        public static var maxSnowStyle : int = 6;
        
        public static var curMemory : Number = 0;
        
        public static var allResIsOK : Boolean = false;
        
        public static var soundManger : SoundManager;
        
        //雪的状态(0:无雪状态,1:小雪状态2:中雪状态3:大雪状态)
        public static var snowState : int = 0;
        public static var snowIsEnd : Boolean = false;
        
        public static var isSnowing : Boolean = false;
        
        public static var soundList : Array = [1,2,3,4,5,5,5,4,3,4,4,4,3,2,1,3,5,1,2,3,4,5,5,5,4,3,4,4,4,3,2,1,3,1,6,6,6,5,4,5,5,5,4,3,4,4,4,3,2,1,3,5,6,6,6,5,4,5,5,5,4,3,4,4,4,3,2,1,3,1];
        public static var soundInex : int = 0;
        
        public static var thinkIceIsOk : Boolean = false;
        
        //0 : 白天 1 : 黑夜
        public static var dayState : int = 0;
        
        public static var curBgMusic : String;
        
        public static var isDarkCloud : Boolean = false;
        
        //当前所选择的语言,默认为中文(cn)。英文为(en)
        public static var curLangage : String = "cn";
        
        //loading是否播放完毕
        public static var loadingIsOk : Boolean = false;
        
        public static var canRunGame : Boolean = false;
        
        //触发大场景动画
        public static var is2012 : Boolean = false;
        
        //成就
        //0 : 大太阳
        //1 : 多云
        //2 : 雪花
        //3 : 滑冰
        public static var achievements : Array = [0, 0, 0, 0];
        
        public static var cloudsM : int = 0;
        public static var maxCloudM : int = 6;
        
        public static var isHouseLightOn : Boolean = false;
        public static var isTowerLightOn : Boolean = false;
        
        public static var startUIIsOK : Boolean = false;
        
        public static var snowmanshow : SnowManShow;
        
        
        //是否装扮过
        public static var hasDressUp : Boolean = false;
        //雪球个数
        public static var snowballNum : int = 0;
        //是否有雪人
        public static var hasSnowMan : Boolean = false;
        
        //太阳是否放大了
        public static var sunIsZoomOut : Boolean = false;
        
        //大太阳,多云,下雪,滚雪球，雪人装扮
        public static var dayDesireList : Array = [0,0,0,0,0];
        //暖和，篝火，睡觉，飞行，滑冰
        public static var nightDesireList : Array = [0, 0, 0, 0, 0];
        
        //应用启动时的时间
        public static var startGameTime : Number = 0;
        
        //愿望完成的时间(大太阳,多云,下雪,滚雪球,雪人装扮,暖和,篝火,睡觉,飞行,滑冰)
        public static var wishCompleteList : Array = [0,0,0,0,0,0,0,0,0,0];
        //
        
        public static var MICACTIVELEVEL : int = 100;//35
        public static var MICACTIVELEVEL1 : int = 50;//20
        
        public static var MICACTIVELEVEL2 : int = 80;
        
        public static var MICACTIVELEVEL_SIGN : int = 70;
        public static var GETSIGNTIME : uint = 1000;
        public static var GETWINDTIME : uint = 1000;
        
        
        public static var frameRate : int;
        public function GameData()
        {
        
        }
        
        public static function resetTrackList():void {
//            for (var i : int = 0; i < trackList.length;i ++ ) {
//                trackList[i][0] *= 1;
//                trackList[i][1] *= 1;
//            }
            
            var firstPoint : Point;
            var secondPoint : Point;
            for (var i: int  = 0; i < trackList.length - 1;i ++ ) {
                firstPoint = new Point(trackList[i][0],trackList[i][1]);
                secondPoint = new Point(trackList[i + 1][0], trackList[i + 1][1]);
                trackKList[i] = (secondPoint.y - firstPoint.y) / (secondPoint.x - firstPoint.x);
                
                trackBList[i] = firstPoint.y - trackKList[i] * firstPoint.x;
            }
        }
        
        public static function setWishComTime(index : int,value : int):void {
            if (wishCompleteList[index] == 0) {
                wishCompleteList[index] = value;
                //勋章点亮了
                PluginControl.BroadcastMsg(new LightIconMsg());
            }
            trace("勋章点亮了 : " + index + ",time : " + value + "  ~~~~~~~~~~~~~~~~~~~~~~~~~~~");
            AnalyticsUtils.sendEvent(index);
        }
        
        
        public static function getCurWish() : Array {
            var list : Array = [];
            for (var i : int = 0; i < wishCompleteList.length;i ++ ) {
                if (wishCompleteList[i] != 0) {
                    list.push(i);
                }
            }
            return list;
        }
        
        public static function initData():void {
            snowIsEnd = false;
            //allResIsOK = false;
            snowState = 0;
            isSnowing = false;
            soundInex = 0;
            thinkIceIsOk = false;
            dayState = 0;
            curBgMusic = null;
            isDarkCloud = false;
            //
            loadingIsOk = true;
            canRunGame = false;
            is2012 = false;
            cloudsM = 0;
            isHouseLightOn = false;
            isTowerLightOn = false;
            //snowmanshow = null;
            
            //
            hasDressUp = false;
            snowballNum = 0;
            hasSnowMan = false;
            sunIsZoomOut = false;
            dayDesireList = [0, 0, 0, 0, 0];
            nightDesireList = [0, 0, 0, 0, 0];
            
            wishCompleteList = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        
            //trackList = [[0,275],[255,150],[535,100],[795,130],[1020,210],[1220,350]];
        }
        
        
        
        
        //获得当前的愿望(暂时这样，需要改为行为树)
        public static function getCurDesire():int {
            if (dayState == 0) {
                //是否有雪
                if (snowState > 0) {
                    if (snowState > 2) {
                        //是否有雪人
                        if (snowballNum > 1) {
                            //是否装扮过
                            if (dayDesireList[4] == 0) {
                                trace("推送雪人装扮");
                                return 4;
                            }
                        }else {
                            trace("推送滚雪球");
                            return 3;
                        }
                    }
                    
                }else {
                    //云彩够6朵么
                    if (cloudsM >= maxCloudM) {
                        trace("推送下雪");
                        return 2;
                    }else {
                        //太阳是否放大
                        if (sunIsZoomOut) {
                            trace("推送多云");
                            return 1;
                        }else {
                            trace("推送大太阳");
                            return 0;
                        }
                    }
                }
            }else {
                
                //是否有雪
                if (snowState > 0) {
                    //是否暖和
                    if (nightDesireList[0] == 1) {
                        //是否滑冰
                        if (nightDesireList[4] == 1) {
                            //是否有雪人
                            if(snowState > 2){
                                if (snowballNum > 1) {
                                    //是否装扮过
                                    if (dayDesireList[4] == 0) {
                                        trace("推送雪人装扮");
                                        return 4;
                                    }
                                }else {
                                    trace("推送滚雪球");
                                    return 3;
                                }
                            }
                        }else {
                            trace("推送滑冰");
                            return 9;
                        }
                    }else {
                        trace("推送暖和");
                        return 5;
                    }
                }else {
                    //是否暖和
                    if (nightDesireList[0] == 1) {
                        //是否有篝火
                        if (nightDesireList[1] == 1) {
                            //是否睡觉
                            if (nightDesireList[2] == 1) {
                                //是否飞行
                                if(nightDesireList[3] == 1){
                                    //是否滑冰
                                    if (nightDesireList[4] == 1) {
                                        //云彩是否够6朵
                                        if (dayDesireList[1] == 1) {
                                            trace("推送下雪");
                                            return 2;
                                        }
                                    }else {
                                        trace("推送滑冰");
                                        return 9;
                                    }
                                }else {
                                    trace("推送飞行");
                                    return 8;
                                }
                            }else {
                                trace("推送睡觉");
                                    //return 7;
                            }
                        }else {
                            trace("推送篝火");
                            return 6;
                        }
                    }else {
                        trace("推送暖和");
                        return 5;
                    }
                    
                }
                
            }
            
            return -1;
        } 
        
        
        public static function resetAchievements(value : int = 0):void {
            if(value == 0){
                dayDesireList = [0, 0, 0, 0, 0];
            }else {
                nightDesireList = [0,0,0,0,0];
            }
        }
        
        public static function getThek(posX : Number):Number {
            var len : int = trackList.length;
            for (var i : int = 0; i < len - 1;i ++ ) {
                var dx1 : Number = trackList[i][0];
                var dx2 : Number = trackList[i + 1][0];
                if (posX >=dx1 && posX <= dx2) {
                    return i;
                    break;
                }
            }
            
            return -1;
        }
        
        /**
         * 根据x轴获取离trackList中最近的一点
         * @return
         */
        public static function getThePosAtoX(posX : Number, posY : Number) : int {
            var len : int = trackList.length;
            var tList : Array = [];
            for (var i : int = 0; i <  len; i ++ ) {
                var obj : Object = { };
                var disX : int = Math.abs(trackList[i][0] - posX);
                obj.index = i;
                obj.dis = disX;
                tList[i] = obj;
            }
            tList.sortOn("dis", Array.NUMERIC);	
            var index : int = tList[0].index;
            return index;
        }
    }
}

