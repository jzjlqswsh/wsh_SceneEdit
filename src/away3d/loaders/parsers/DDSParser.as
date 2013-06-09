package away3d.loaders.parsers
{
    import away3d.loaders.parsers.utils.*;
    import away3d.textures.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.*;

    public class DDSParser extends ParserBase
    {
        private var _byteData:ByteArray;
        private var _startedParsing:Boolean;
        private var _doneParsing:Boolean;
        private var _loader:Loader;

        public function DDSParser()
        {
            super(ParserDataFormat.BINARY);
            return;
        }// end function

        override protected function proceedParsing() : Boolean
        {
            var _loc_1:Texture2DBase = null;
            var _loc_2:ByteArray = null;
            this._byteData = getByteData();
            _loc_2 = DDSTool.getInstance().uncompressDDS(this._byteData);
            var _loc_3:* = DDSTool.getInstance().width;
            var _loc_4:* = DDSTool.getInstance().height;
            var _loc_5:* = DDSTool.getInstance().dxtFormat == DDSTool.DXT5 ? (true) : (false);
            var _loc_6:* = new BitmapData(_loc_3, _loc_4, _loc_5, 0);
            new BitmapData(_loc_3, _loc_4, _loc_5, 0).setPixels(new Rectangle(0, 0, _loc_3, _loc_4), _loc_2);
            _loc_1 = new BitmapTexture(_loc_6);
            finalizeAsset(_loc_1, _fileName);
            return PARSING_DONE;
        }// end function

        public static function supportsType(param1:String) : Boolean
        {
            param1 = param1.toLowerCase();
            return param1 == "dds";
        }// end function

        public static function supportsData(param1) : Boolean
        {
            return false;
        }// end function

    }
}
