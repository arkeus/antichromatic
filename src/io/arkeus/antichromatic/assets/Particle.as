package io.arkeus.antichromatic.assets {
	import io.arkeus.antichromatic.util.ParticleGroup;
	
	import org.axgl.AxGroup;
	import org.axgl.particle.AxParticleEffect;
	import org.axgl.particle.AxParticleSystem;
	import org.axgl.render.AxBlendMode;

	public class Particle {
		public static const BULLET:String = "bullet";
		public static const EXPLOSION:String = "explosion";
		public static const WHITE_CRATE:String = "white-crate";
		public static const BLACK_CRATE:String = "black-create";
		public static const RED:String = "red";
		public static const GREEN:String = "green";
		public static const BLUE:String = "blue";
		public static const RAINBOW:String = "rainbow";
		public static const TILE:String = "tile";
		
		private static var group:AxGroup;
		
		public static function initialize():AxGroup {
			if (group != null) {
				return group;
			}
			
			group = new ParticleGroup;
			var effect:AxParticleEffect;
			
			effect = new AxParticleEffect(BULLET, Resource.PARTICLE_GUN_BLACK, 50);
			effect.amount = 20;
			effect.x.min = -2; effect.x.max = 2;
			effect.y.min = -2; effect.y.max = 2;
			effect.frameSize.x = effect.frameSize.y = 2;
			effect.blend = AxBlendMode.PARTICLE;
			effect.xVelocity.min = -60; effect.xVelocity.max = 60;
			effect.yVelocity.min = -120; effect.yVelocity.max = 10;
			effect.yAcceleration.min = 200; effect.yAcceleration.max = 600;
			effect.lifetime.min = 1; effect.lifetime.max = 2;
			group.add(AxParticleSystem.register(effect));
			
			effect = new AxParticleEffect(WHITE_CRATE, Resource.PARTICLE_CRATE_WHITE, 20);
			effect.amount = 10;
			effect.x.min = 0; effect.x.max = 6;
			effect.y.min = 0; effect.y.max = 6;
			effect.frameSize.x = effect.frameSize.y = 6;
			//effect.blend = AxBlendMode.PARTICLE;
			effect.xVelocity.min = -30; effect.xVelocity.max = 30;
			effect.yVelocity.min = -60; effect.yVelocity.max = -10;
			effect.yAcceleration.min = 400; effect.yAcceleration.max = 600;
			effect.lifetime.min = 1; effect.lifetime.max = 2;
			group.add(AxParticleSystem.register(effect));
			
			effect = new AxParticleEffect(BLACK_CRATE, Resource.PARTICLE_CRATE_BLACK, 20);
			effect.amount = 10;
			effect.x.min = 0; effect.x.max = 6;
			effect.y.min = 0; effect.y.max = 6;
			effect.frameSize.x = effect.frameSize.y = 6;
			//effect.blend = AxBlendMode.PARTICLE;
			effect.xVelocity.min = -60; effect.xVelocity.max = 60;
			effect.yVelocity.min = -100; effect.yVelocity.max = -200;
			effect.yAcceleration.min = 400; effect.yAcceleration.max = 600;
			effect.lifetime.min = 0.5; effect.lifetime.max = 1.5;
			group.add(AxParticleSystem.register(effect));
			
			effect = new AxParticleEffect(EXPLOSION, Resource.PARTICLE_GUN_BLACK, 5);
			effect.amount = 500;
			effect.x.min = -2; effect.x.max = 2;
			effect.y.min = -2; effect.y.max = 2;
			effect.frameSize.x = effect.frameSize.y = 2;
			effect.blend = AxBlendMode.PARTICLE;
			effect.xVelocity.min = -150; effect.xVelocity.max = 150;
			effect.yVelocity.min = -220; effect.yVelocity.max = 10;
			effect.yAcceleration.min = 200; effect.yAcceleration.max = 600;
			effect.lifetime.min = 1; effect.lifetime.max = 2;
			group.add(AxParticleSystem.register(effect));
			
			effect = new AxParticleEffect(RED, Resource.PARTICLE_RED, 15);
			effect.amount = 50;
			effect.x.min = 0; effect.x.max = 6;
			effect.y.min = 0; effect.y.max = 6;
			effect.frameSize.x = effect.frameSize.y = 6;
			//effect.blend = AxBlendMode.PARTICLE;
			effect.xVelocity.min = -100; effect.xVelocity.max = 100;
			effect.yVelocity.min = -300; effect.yVelocity.max = -10;
			effect.yAcceleration.min = 400; effect.yAcceleration.max = 600;
			effect.lifetime.min = 1; effect.lifetime.max = 2;
			group.add(AxParticleSystem.register(effect));
			
			effect = new AxParticleEffect(GREEN, Resource.PARTICLE_GREEN, 15);
			effect.amount = 50;
			effect.x.min = 0; effect.x.max = 6;
			effect.y.min = 0; effect.y.max = 6;
			effect.frameSize.x = effect.frameSize.y = 6;
			//effect.blend = AxBlendMode.PARTICLE;
			effect.xVelocity.min = -100; effect.xVelocity.max = 100;
			effect.yVelocity.min = -300; effect.yVelocity.max = -10;
			effect.yAcceleration.min = 400; effect.yAcceleration.max = 600;
			effect.lifetime.min = 1; effect.lifetime.max = 2;
			group.add(AxParticleSystem.register(effect));
			
			effect = new AxParticleEffect(BLUE, Resource.PARTICLE_BLUE, 15);
			effect.amount = 50;
			effect.x.min = 0; effect.x.max = 6;
			effect.y.min = 0; effect.y.max = 6;
			effect.frameSize.x = effect.frameSize.y = 6;
			//effect.blend = AxBlendMode.PARTICLE;
			effect.xVelocity.min = -100; effect.xVelocity.max = 100;
			effect.yVelocity.min = -300; effect.yVelocity.max = -10;
			effect.yAcceleration.min = 400; effect.yAcceleration.max = 600;
			effect.lifetime.min = 1; effect.lifetime.max = 2;
			group.add(AxParticleSystem.register(effect));
			
			effect = new AxParticleEffect(RAINBOW, Resource.PARTICLE_RAINBOW, 3);
			effect.amount = 500;
			effect.x.min = -3; effect.x.max = 3;
			effect.y.min = -3; effect.y.max = 3;
			effect.frameSize.x = effect.frameSize.y = 6;
			//effect.blend = AxBlendMode.PARTICLE;
			effect.xVelocity.min = -400; effect.xVelocity.max = 400;
			effect.yVelocity.min = -800; effect.yVelocity.max = 20;
			effect.yAcceleration.min = 400; effect.yAcceleration.max = 600;
			effect.lifetime.min = 1; effect.lifetime.max = 2;
			group.add(AxParticleSystem.register(effect));
			
			effect = new AxParticleEffect(TILE, Resource.PARTICLE_TILE, 20);
			effect.amount = 1;
			effect.x.min = 0; effect.x.max = 0;
			effect.y.min = 0; effect.y.max = 0;
			effect.frameSize.x = effect.frameSize.y = 12;
			//effect.blend = AxBlendMode.PARTICLE;
			effect.xVelocity.min = 0; effect.xVelocity.max = 0;
			effect.yVelocity.min = 0; effect.yVelocity.max = 0;
			effect.lifetime.min = 1; effect.lifetime.max = 2;
			effect.startAlpha.min = 1; effect.startAlpha.max = 1;
			effect.endAlpha.min = 0; effect.endAlpha.max = 0;
			//effect.endScale.min = 3; effect.endScale.max = 6;
			group.add(AxParticleSystem.register(effect));
			
			return group;
		}
	}
}
