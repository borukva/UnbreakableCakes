package ua.borukva.UnbreakableCakes.mixin;

import com.llamalad7.mixinextras.injector.wrapoperation.Operation;
import com.llamalad7.mixinextras.injector.wrapoperation.WrapOperation;
import java.util.function.Function;
import net.minecraft.resources.ResourceKey;
import net.minecraft.world.level.block.Block;
import net.minecraft.world.level.block.Blocks;
import net.minecraft.world.level.block.CakeBlock;
import net.minecraft.world.level.block.SoundType;
import net.minecraft.world.level.block.state.BlockBehaviour;
import net.minecraft.world.level.block.state.BlockBehaviour.Properties;
import net.minecraft.world.level.block.state.BlockState;
import net.minecraft.world.level.material.PushReaction;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.ModifyVariable;

@SuppressWarnings("unused")
public class CakeMixins {

  @Mixin(Blocks.class)
  public static class CakePropertiesMixin {
    @ModifyVariable(
        method = "register(Lnet/minecraft/resources/ResourceKey;Ljava/util/function/Function;Lnet/minecraft/world/level/block/state/BlockBehaviour$Properties;)Lnet/minecraft/world/level/block/Block;",
        at = @At(value = "HEAD"),
        argsOnly = true,
        ordinal = 0
    )
    private static Properties replaceCakeProperties(Properties properties,
        ResourceKey<Block> resourceKey, Function<Properties, Block> function) {
      if (resourceKey.location().getPath().equals("cake")) {
        return BlockBehaviour.Properties.of()
            .strength(0.5F)
            .sound(SoundType.WOOL)
            .pushReaction(PushReaction.PUSH_ONLY);
      }
      return properties;
    }
  }

  @Mixin(CakeBlock.class)
  public static class CakeBlockMixin {
    @WrapOperation(
        method = "canSurvive(Lnet/minecraft/world/level/block/state/BlockState;Lnet/minecraft/world/level/LevelReader;Lnet/minecraft/core/BlockPos;)Z",
        at = @At(value = "INVOKE", target = "Lnet/minecraft/world/level/block/state/BlockState;isSolid()Z")
    )
    private static boolean replaceCakeProperties(BlockState instance, Operation<Boolean> original) {
      return true;
    }
  }
}
