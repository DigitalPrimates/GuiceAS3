package integration.scenarios.classes.computer {
	import net.digitalprimates.guice.Binder;

	public class MotherBoard {
		private var processor:Processor;
		private var videoCard:VideoCard;
		private var memory:Vector.<Memory>;
		
		public function MotherBoard( processor:Processor, memory:Vector.<Memory>, videoCard:VideoCard=null ) {
			this.processor = processor;
			this.memory = memory;
			this.videoCard = videoCard;
		}
	}
}